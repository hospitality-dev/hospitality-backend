use reqwest::{Client, StatusCode};
use serde::{Deserialize, Serialize};
use serde_json::Value;
use std::collections::HashMap;
use uuid::Uuid;

use crate::enums::{
    actions::{ActionEffect, Actions},
    errors::AppError,
    models::Models,
    requests::{CerbosAttrValue, CerbosOperators},
    roles::Roles,
};

use super::{auth::AuthUserPermissions, response::AppErrorResponse, state::AppState};

// ================== CERBOS SETUP ==================

#[derive(Debug, Serialize, Deserialize)]
pub struct CerbosPrincipal {
    pub id: String,
    pub scope: Option<String>,
    pub roles: Vec<Roles>,
    pub attr: Option<HashMap<String, CerbosAttrValue>>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct CerbosResource {
    pub id: String,
    pub kind: String,
    pub scope: Option<String>,
    pub attr: Option<HashMap<String, CerbosAttrValue>>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct CerbosCheck {
    #[serde(rename = "requestId")]
    pub model: Models,
    // pub actions: Vec<Actions>,
    pub action: Actions,
    pub principal: CerbosPrincipal,
    pub resources: Vec<CerbosResource>,
}
#[derive(Debug, Deserialize)]
pub struct CerbosResult {
    pub resource: CerbosResource,
    pub actions: HashMap<String, ActionEffect>,
}
#[derive(Debug, Deserialize)]
pub struct CerbosResponse {
    pub results: Vec<CerbosResult>,
}
#[derive(Debug, Deserialize)]
#[serde(rename_all = "SCREAMING_SNAKE_CASE")]
pub enum CerbosPlanFilterKind {
    KindAlwaysAllowed,
    KindAlwaysDenied,
    KindConditional,
}
#[derive(Debug, Deserialize)]
#[serde(untagged)]
pub enum Operand {
    Variable { variable: String },
    Value { value: serde_json::Value },
    Expression { expression: Box<CerbosExpression> },
}

#[derive(Debug, Deserialize)]
pub struct CerbosExpression {
    pub operator: CerbosOperators,
    pub operands: Vec<Operand>,
}
#[derive(Debug, Deserialize)]

pub struct CerbosCondition {
    pub expression: CerbosExpression,
}
#[derive(Debug, Deserialize)]
pub struct CerbosFilter {
    pub kind: CerbosPlanFilterKind,
    pub condition: Option<CerbosCondition>,
}
#[derive(Debug, Deserialize)]
pub struct CerbosCheckResponse {
    pub filter: CerbosFilter,
}

impl CerbosCheck {
    pub async fn is_allowed_model(
        &self,
        client: &Client,
        url: &String,
    ) -> Result<bool, AppErrorResponse> {
        let actions: Vec<String> = vec![self.action.to_string()];
        let model_req_body = serde_json::json!({
            "requestId": Uuid::new_v4(),
            "principal": {
                "id": self.principal.id,
                "scope": "",
                "roles": self.principal.roles,
            },
            "resources": vec![serde_json::json!({"resource": {"id":self.model.to_string(),"kind": format!("{}:model", self.model.to_string())},"actions":actions})],
            "includeMeta": true
        });
        let model_response = client
            .post(format!("{}/api/check/resources", url))
            .json(&model_req_body)
            .send()
            .await
            .map_err(AppError::forbidden_response)?;

        let model_check: CerbosResponse = model_response.json::<CerbosResponse>().await.unwrap();
        if let Some(model_res) = model_check.results.get(0) {
            if let Some(action) = model_res.actions.get(&self.action.to_string()) {
                if action == &ActionEffect::EffectAllow {
                    return Ok(true);
                }
            }
        }
        return Ok(false);
    }
    pub async fn is_allowed_fields(
        self,
        client: &Client,
        url: &String,
    ) -> Result<Vec<String>, AppErrorResponse> {
        let actions: Vec<String> = vec![self.action.to_string()];

        let resources: Vec<Value> = self
            .resources
            .iter()
            .map(|r| serde_json::json!({"resource": {"id":r.id,"kind": r.kind, "attr": None::<String>},"actions":actions}))
            .collect();
        let req_body = serde_json::json!({
            "requestId": Uuid::new_v4(),
            "principal": {
                "id": self.principal.id,
                "scope": "",
                "roles": self.principal.roles,
                "attr": self.principal.attr
            },
            "resources": resources,
            "includeMeta": true
        });

        let p = client
            .post(format!("{}/api/check/resources", url))
            .json(&req_body)
            .send()
            .await
            .map_err(AppError::forbidden_response)?;

        if p.status() == StatusCode::BAD_REQUEST {
            let check = p.text().await.map_err(AppError::critical_error)?;
            return Err(AppError::critical_error(format!(
                "CERBOS REQUEST ERROR - {}",
                check
            )));
        } else {
            let check: CerbosResponse = p
                .json::<CerbosResponse>()
                .await
                .map_err(AppError::critical_error)?;

            let mut fields: Vec<String> = Vec::new();

            for c in check.results {
                match c.actions.get(&self.action.to_string()) {
                    Some(act) => {
                        if act == &ActionEffect::EffectAllow {
                            if let Some(kind) = c.resource.kind.split(":").nth(1) {
                                fields.push(kind.to_string());
                            }
                        }
                    }
                    _ => {}
                }
            }

            return Ok(fields);
        }
    }
    pub async fn get_permissions(
        &self,
        state: &AppState,
    ) -> Result<HashMap<String, bool>, AppErrorResponse> {
        let resources: Vec<Value> = self
        .resources
        .iter()
        .map(|r| serde_json::json!({"resource": {"id":r.id,"kind": r.kind, "attr": r.attr},"actions":vec![self.action.to_string()]}))
        .collect();
        let req_body = serde_json::json!({
            "requestId": Uuid::new_v4(),
            "principal": self.principal,
            "resources": resources,
            "includeMeta": true
        });

        let p = state
            .rqw_client
            .post(format!("{}/api/check/resources", state.cerbos_url))
            .json(&req_body)
            .send()
            .await
            .map_err(AppError::forbidden_response)?;

        let check: CerbosResponse = p
            .json::<CerbosResponse>()
            .await
            .map_err(AppError::critical_error)?;

        let formatted: HashMap<String, bool> = check
            .results
            .iter()
            .map(|r| {
                (
                    r.resource.id.to_string(),
                    r.actions
                        .get(&self.action.to_string())
                        .unwrap_or(&ActionEffect::EffectDeny)
                        == &ActionEffect::EffectAllow,
                )
            })
            .collect();

        return Ok(formatted);
    }
    pub async fn check_permission(self, state: &AppState) -> Result<bool, AppErrorResponse> {
        let permission_item = &self.resources.get(0);
        if permission_item.is_none() {
            return Err(AppError::critical_error("NO RESOURCES IN CERBOS CHECK."));
        }
        let permission_item = permission_item.unwrap();
        let permissions = self.get_permissions(state).await?;
        let has_permission = permissions.get(&permission_item.id);

        match has_permission {
            Some(perm) => {
                if perm == &true {
                    return Ok(true);
                } else {
                    return Ok(false);
                }
            }
            None => {
                return Err(AppError::forbidden_response(
                    "Current user does not have required permissions - permission is NONE.",
                ));
            }
        }
    }
}

impl CerbosResponse {
    pub fn map_to_hashmap(self) -> AuthUserPermissions {
        let mut result_map = HashMap::new();

        for result in self.results {
            let action_map = result
                .actions
                .into_iter()
                .map(|(action, effect)| (action, matches!(effect, ActionEffect::EffectAllow)))
                .collect();

            result_map.insert(result.resource.kind.replace(":model", ""), action_map);
        }

        result_map
    }
}
