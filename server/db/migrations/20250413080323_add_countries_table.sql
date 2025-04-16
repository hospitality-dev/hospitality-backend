-- migrate:up
CREATE TABLE IF NOT EXISTS
    regions (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        title TEXT NOT NULL,
        "wikiDataId" TEXT
    );

CREATE TABLE IF NOT EXISTS
    subregions (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        title TEXT NOT NULL,
        region_id UUID NOT NULL REFERENCES regions (id) ON DELETE CASCADE,
        "wikiDataId" TEXT
    );

-- #region REGIONS
INSERT INTO
    regions
VALUES
    (
        '44257098-ebbc-4288-a53e-c0c74dd79f0b',
        'Africa',
        'Q15'
    );

INSERT INTO
    regions
VALUES
    (
        '586f2a1b-ad75-4dbc-8381-0cf26a48929d',
        'Americas',
        'Q828'
    );

INSERT INTO
    regions
VALUES
    (
        '847f59ee-a9ac-4552-bd26-3003d6f3df80',
        'Asia',
        'Q48'
    );

INSERT INTO
    regions
VALUES
    (
        '081be89e-e707-451c-a04c-51a994aeb058',
        'Europe',
        'Q46'
    );

INSERT INTO
    regions
VALUES
    (
        '209ccf09-dc1b-45d3-8b79-a400fa72c744',
        'Oceania',
        'Q55643'
    );

-- #endregion REGIONS
-- #region SUBREGIONS
INSERT INTO
    subregions
VALUES
    (
        '257da5dd-4303-4d9f-8270-a560c8d946ae',
        'Northern Africa',
        '44257098-ebbc-4288-a53e-c0c74dd79f0b',
        'Q27381'
    );

INSERT INTO
    subregions
VALUES
    (
        'db6f6a6f-ac9d-4374-8a81-e12a56dceb8f',
        'Middle Africa',
        '44257098-ebbc-4288-a53e-c0c74dd79f0b',
        'Q27433'
    );

INSERT INTO
    subregions
VALUES
    (
        '82d1178f-8238-4466-bf2b-23e8a95e9344',
        'Western Africa',
        '44257098-ebbc-4288-a53e-c0c74dd79f0b',
        'Q4412'
    );

INSERT INTO
    subregions
VALUES
    (
        'a47c2972-c70d-4c03-b635-1060b6d8b228',
        'Eastern Africa',
        '44257098-ebbc-4288-a53e-c0c74dd79f0b',
        'Q27407'
    );

INSERT INTO
    subregions
VALUES
    (
        'd6a4bf48-5b45-4a28-9e24-5af5c2c9a76f',
        'Southern Africa',
        '44257098-ebbc-4288-a53e-c0c74dd79f0b',
        'Q27394'
    );

INSERT INTO
    subregions
VALUES
    (
        '11b0736f-07c3-42e5-b434-a5af08c05af0',
        'Northern America',
        '586f2a1b-ad75-4dbc-8381-0cf26a48929d',
        'Q2017699'
    );

INSERT INTO
    subregions
VALUES
    (
        'a0f8efd8-72be-47aa-aedf-7a7473fdc4c5',
        'Caribbean',
        '586f2a1b-ad75-4dbc-8381-0cf26a48929d',
        'Q664609'
    );

INSERT INTO
    subregions
VALUES
    (
        'ec851ade-8eca-442c-894c-260dc960b930',
        'South America',
        '586f2a1b-ad75-4dbc-8381-0cf26a48929d',
        'Q18'
    );

INSERT INTO
    subregions
VALUES
    (
        '1cdc20c3-9873-4dd9-973b-e27a5ab31881',
        'Central America',
        '586f2a1b-ad75-4dbc-8381-0cf26a48929d',
        'Q27611'
    );

INSERT INTO
    subregions
VALUES
    (
        '47a247c2-63f1-46c3-b9e9-234d6e25836f',
        'Central Asia',
        '847f59ee-a9ac-4552-bd26-3003d6f3df80',
        'Q27275'
    );

INSERT INTO
    subregions
VALUES
    (
        '02567284-8081-4b81-8ba9-d668073e8321',
        'Western Asia',
        '847f59ee-a9ac-4552-bd26-3003d6f3df80',
        'Q27293'
    );

INSERT INTO
    subregions
VALUES
    (
        'ae0c6a46-d55e-4e52-8ffc-d0367c2623cf',
        'Eastern Asia',
        '847f59ee-a9ac-4552-bd26-3003d6f3df80',
        'Q27231'
    );

INSERT INTO
    subregions
VALUES
    (
        '72beac8e-ccef-4285-b3be-5373f69da329',
        'South-Eastern Asia',
        '847f59ee-a9ac-4552-bd26-3003d6f3df80',
        'Q11708'
    );

INSERT INTO
    subregions
VALUES
    (
        '28d46c29-0171-4337-a853-f74df9a9ae2c',
        'Southern Asia',
        '847f59ee-a9ac-4552-bd26-3003d6f3df80',
        'Q771405'
    );

INSERT INTO
    subregions
VALUES
    (
        '370b6713-d88d-4640-a9a8-2f855b5bf304',
        'Eastern Europe',
        '081be89e-e707-451c-a04c-51a994aeb058',
        'Q27468'
    );

INSERT INTO
    subregions
VALUES
    (
        '870236e5-493d-4f35-ad65-4102137f3131',
        'Southern Europe',
        '081be89e-e707-451c-a04c-51a994aeb058',
        'Q27449'
    );

INSERT INTO
    subregions
VALUES
    (
        '2f4c0766-b497-4146-a0a0-581e02c2e292',
        'Western Europe',
        '081be89e-e707-451c-a04c-51a994aeb058',
        'Q27496'
    );

INSERT INTO
    subregions
VALUES
    (
        'b809c2e0-40a9-43b1-87df-9efaf1bf6069',
        'Northern Europe',
        '081be89e-e707-451c-a04c-51a994aeb058',
        'Q27479'
    );

INSERT INTO
    subregions
VALUES
    (
        'c500a779-15a7-49a9-9bae-43394c7e59b5',
        'Australia and New Zealand',
        '209ccf09-dc1b-45d3-8b79-a400fa72c744',
        'Q45256'
    );

INSERT INTO
    subregions
VALUES
    (
        '45fb0ccf-c5db-4ab2-acb6-eed633154336',
        'Melanesia',
        '209ccf09-dc1b-45d3-8b79-a400fa72c744',
        'Q37394'
    );

INSERT INTO
    subregions
VALUES
    (
        'b9ad9fb2-e9b3-49b5-9604-2f344e48db39',
        'Micronesia',
        '209ccf09-dc1b-45d3-8b79-a400fa72c744',
        'Q3359409'
    );

INSERT INTO
    subregions
VALUES
    (
        'da7e1ca7-8a96-40ee-b26b-5c7a1b921f2e',
        'Polynesia',
        '209ccf09-dc1b-45d3-8b79-a400fa72c744',
        'Q35942'
    );

-- #endregion SUBREGIONS
CREATE TABLE IF NOT EXISTS
    countries (
        -- DELETED AFTER DATA ENTRY
        temp_id bigint NOT NULL,
        title TEXT NOT NULL,
        iso3 TEXT,
        numeric_code TEXT,
        iso2 TEXT,
        phonecode TEXT,
        capital TEXT,
        currency TEXT,
        currency_name TEXT,
        currency_symbol TEXT,
        tld TEXT,
        -- DELETED AFTER DATA ENTRY
        native TEXT,
        -- DELETED AFTER DATA ENTRY
        region TEXT,
        -- DELETED AFTER DATA ENTRY
        temp_region_id bigint,
        -- DELETED AFTER DATA ENTRY
        subregion TEXT,
        -- DELETED AFTER DATA ENTRY
        temp_subregion_id bigint,
        nationality TEXT,
        timezones JSONB,
        -- DELETED AFTER DATA ENTRY
        translations JSONB,
        latitude numeric(10, 8),
        longitude numeric(11, 8),
        -- DELETED AFTER DATA ENTRY
        emoji TEXT,
        -- DELETED AFTER DATA ENTRY
        "emojiU" TEXT,
        -- DELETED AFTER DATA ENTRY
        created_at timestamp without time zone,
        -- DELETED AFTER DATA ENTRY
        updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
        -- DELETED AFTER DATA ENTRY
        flag smallint DEFAULT 1 NOT NULL,
        "wikiDataId" TEXT,
        id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid (),
        region_id UUID REFERENCES regions (id),
        subregion_id UUID REFERENCES subregions (id)
    );

-- #region COUNTRIES
INSERT INTO
    public.countries
VALUES
    (
        1,
        'Afghanistan',
        'AFG',
        '004',
        'AF',
        '93',
        'Kabul',
        'AFN',
        'Afghan afghani',
        '؋',
        '.af',
        'افغانستان',
        'Asia',
        3,
        'Southern Asia',
        14,
        'Afghan',
        '[{"zoneName":"Asia/Kabul","gmtOffset":16200,"gmtOffsetName":"UTC+04:30","abbreviation":"AFT","tzName":"Afghanistan Time"}]',
        '{"ko":"아프가니스탄","pt-BR":"Afeganistão","pt":"Afeganistão","nl":"Afghanistan","hr":"Afganistan","fa":"افغانستان","de":"Afghanistan","es":"Afganistán","fr":"Afghanistan","ja":"アフガニスタン","it":"Afghanistan","zh-CN":"阿富汗","tr":"Afganistan","ru":"Афганистан","uk":"Афганістан","pl":"Afganistan"}',
        33.00000000,
        65.00000000,
        '🇦🇫',
        'U+1F1E6 U+1F1EB',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q889'
    );

INSERT INTO
    public.countries
VALUES
    (
        2,
        'Aland Islands',
        'ALA',
        '248',
        'AX',
        '358',
        'Mariehamn',
        'EUR',
        'Euro',
        '€',
        '.ax',
        'Åland',
        'Europe',
        4,
        'Northern Europe',
        18,
        'Aland Island',
        '[{"zoneName":"Europe/Mariehamn","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"올란드 제도","pt-BR":"Ilhas de Aland","pt":"Ilhas de Aland","nl":"Ålandeilanden","hr":"Ålandski otoci","fa":"جزایر الند","de":"Åland","es":"Alandia","fr":"Åland","ja":"オーランド諸島","it":"Isole Aland","zh-CN":"奥兰群岛","tr":"Åland Adalari","ru":"Аландские острова","uk":"Аландські острови","pl":"Wyspy Alandzkie"}',
        60.11666700,
        19.90000000,
        '🇦🇽',
        'U+1F1E6 U+1F1FD',
        '2018-07-21 12:41:03',
        '2024-12-19 20:22:33',
        1,
        'Q5689'
    );

INSERT INTO
    public.countries
VALUES
    (
        3,
        'Albania',
        'ALB',
        '008',
        'AL',
        '355',
        'Tirana',
        'ALL',
        'Albanian lek',
        'Lek',
        '.al',
        'Shqipëria',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Albanian ',
        '[{"zoneName":"Europe/Tirane","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"알바니아","pt-BR":"Albânia","pt":"Albânia","nl":"Albanië","hr":"Albanija","fa":"آلبانی","de":"Albanien","es":"Albania","fr":"Albanie","ja":"アルバニア","it":"Albania","zh-CN":"阿尔巴尼亚","tr":"Arnavutluk","ru":"Албания","uk":"Албанія","pl":"Albania"}',
        41.00000000,
        20.00000000,
        '🇦🇱',
        'U+1F1E6 U+1F1F1',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q222'
    );

INSERT INTO
    public.countries
VALUES
    (
        4,
        'Algeria',
        'DZA',
        '012',
        'DZ',
        '213',
        'Algiers',
        'DZD',
        'Algerian dinar',
        'دج',
        '.dz',
        'الجزائر',
        'Africa',
        1,
        'Northern Africa',
        1,
        'Algerian',
        '[{"zoneName":"Africa/Algiers","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"알제리","pt-BR":"Argélia","pt":"Argélia","nl":"Algerije","hr":"Alžir","fa":"الجزایر","de":"Algerien","es":"Argelia","fr":"Algérie","ja":"アルジェリア","it":"Algeria","zh-CN":"阿尔及利亚","tr":"Cezayir","ru":"Алжир","uk":"Алжир","pl":"Algieria"}',
        28.00000000,
        3.00000000,
        '🇩🇿',
        'U+1F1E9 U+1F1FF',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q262'
    );

INSERT INTO
    public.countries
VALUES
    (
        5,
        'American Samoa',
        'ASM',
        '016',
        'AS',
        '1',
        'Pago Pago',
        'USD',
        'United States dollar',
        '$',
        '.as',
        'American Samoa',
        'Oceania',
        5,
        'Polynesia',
        22,
        'American Samoan',
        '[{"zoneName":"Pacific/Pago_Pago","gmtOffset":-39600,"gmtOffsetName":"UTC-11:00","abbreviation":"SST","tzName":"Samoa Standard Time"}]',
        '{"ko":"아메리칸사모아","pt-BR":"Samoa Americana","pt":"Samoa Americana","nl":"Amerikaans Samoa","hr":"Američka Samoa","fa":"ساموآی آمریکا","de":"Amerikanisch-Samoa","es":"Samoa Americana","fr":"Samoa américaines","ja":"アメリカ領サモア","it":"Samoa Americane","zh-CN":"美属萨摩亚","tr":"Amerikan Samoasi","ru":"Американское Самоа","uk":"Американське Самоа","pl":"Samoa Amerykańskie"}',
        -14.33333333,
        -170.00000000,
        '🇦🇸',
        'U+1F1E6 U+1F1F8',
        '2018-07-21 12:41:03',
        '2024-12-23 15:33:12',
        1,
        'Q16641'
    );

INSERT INTO
    public.countries
VALUES
    (
        6,
        'Andorra',
        'AND',
        '020',
        'AD',
        '376',
        'Andorra la Vella',
        'EUR',
        'Euro',
        '€',
        '.ad',
        'Andorra',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Andorran',
        '[{"zoneName":"Europe/Andorra","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"안도라","pt-BR":"Andorra","pt":"Andorra","nl":"Andorra","hr":"Andora","fa":"آندورا","de":"Andorra","es":"Andorra","fr":"Andorre","ja":"アンドラ","it":"Andorra","zh-CN":"安道尔","tr":"Andorra","ru":"Андорра","uk":"Андорра","pl":"Andora"}',
        42.50000000,
        1.50000000,
        '🇦🇩',
        'U+1F1E6 U+1F1E9',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q228'
    );

INSERT INTO
    public.countries
VALUES
    (
        7,
        'Angola',
        'AGO',
        '024',
        'AO',
        '244',
        'Luanda',
        'AOA',
        'Angolan kwanza',
        'Kz',
        '.ao',
        'Angola',
        'Africa',
        1,
        'Middle Africa',
        2,
        'Angolan',
        '[{"zoneName":"Africa/Luanda","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"WAT","tzName":"West Africa Time"}]',
        '{"ko":"앙골라","pt-BR":"Angola","pt":"Angola","nl":"Angola","hr":"Angola","fa":"آنگولا","de":"Angola","es":"Angola","fr":"Angola","ja":"アンゴラ","it":"Angola","zh-CN":"安哥拉","tr":"Angola","ru":"Ангола","uk":"Ангола","pl":"Angola"}',
        -12.50000000,
        18.50000000,
        '🇦🇴',
        'U+1F1E6 U+1F1F4',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q916'
    );

INSERT INTO
    public.countries
VALUES
    (
        8,
        'Anguilla',
        'AIA',
        '660',
        'AI',
        '1',
        'The Valley',
        'XCD',
        'Eastern Caribbean dollar',
        '$',
        '.ai',
        'Anguilla',
        'Americas',
        2,
        'Caribbean',
        7,
        'Anguillan',
        '[{"zoneName":"America/Anguilla","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"앵귈라","pt-BR":"Anguila","pt":"Anguila","nl":"Anguilla","hr":"Angvila","fa":"آنگویلا","de":"Anguilla","es":"Anguilla","fr":"Anguilla","ja":"アンギラ","it":"Anguilla","zh-CN":"安圭拉","tr":"Anguilla","ru":"Ангилья","uk":"Ангілья","pl":"Anguilla"}',
        18.25000000,
        -63.16666666,
        '🇦🇮',
        'U+1F1E6 U+1F1EE',
        '2018-07-21 12:41:03',
        '2024-12-23 15:33:12',
        1,
        'Q25228'
    );

INSERT INTO
    public.countries
VALUES
    (
        74,
        'Finland',
        'FIN',
        '246',
        'FI',
        '358',
        'Helsinki',
        'EUR',
        'Euro',
        '€',
        '.fi',
        'Suomi',
        'Europe',
        4,
        'Northern Europe',
        18,
        'Finnish',
        '[{"zoneName":"Europe/Helsinki","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"핀란드","pt-BR":"Finlândia","pt":"Finlândia","nl":"Finland","hr":"Finska","fa":"فنلاند","de":"Finnland","es":"Finlandia","fr":"Finlande","ja":"フィンランド","it":"Finlandia","zh-CN":"芬兰","tr":"Finlandiya","ru":"Финляндия","uk":"Фінляндія","pl":"Finlandia"}',
        64.00000000,
        26.00000000,
        '🇫🇮',
        'U+1F1EB U+1F1EE',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q33'
    );

INSERT INTO
    public.countries
VALUES
    (
        10,
        'Antigua and Barbuda',
        'ATG',
        '028',
        'AG',
        '1',
        'St. John''s',
        'XCD',
        'Eastern Caribbean dollar',
        '$',
        '.ag',
        'Antigua and Barbuda',
        'Americas',
        2,
        'Caribbean',
        7,
        'Antiguan or Barbudan',
        '[{"zoneName":"America/Antigua","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"앤티가 바부다","pt-BR":"Antígua e Barbuda","pt":"Antígua e Barbuda","nl":"Antigua en Barbuda","hr":"Antigva i Barbuda","fa":"آنتیگوا و باربودا","de":"Antigua und Barbuda","es":"Antigua y Barbuda","fr":"Antigua-et-Barbuda","ja":"アンティグア・バーブーダ","it":"Antigua e Barbuda","zh-CN":"安提瓜和巴布达","tr":"Antigua Ve Barbuda","ru":"Антигуа и Барбуда","uk":"Антигуа і Барбуда","pl":"Antigua i Barbuda"}',
        17.05000000,
        -61.80000000,
        '🇦🇬',
        'U+1F1E6 U+1F1EC',
        '2018-07-21 12:41:03',
        '2024-09-05 16:47:03',
        1,
        'Q781'
    );

INSERT INTO
    public.countries
VALUES
    (
        11,
        'Argentina',
        'ARG',
        '032',
        'AR',
        '54',
        'Buenos Aires',
        'ARS',
        'Argentine peso',
        '$',
        '.ar',
        'Argentina',
        'Americas',
        2,
        'South America',
        8,
        'Argentine',
        '[{"zoneName":"America/Argentina/Buenos_Aires","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"ART","tzName":"Argentina Time"},{"zoneName":"America/Argentina/Catamarca","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"ART","tzName":"Argentina Time"},{"zoneName":"America/Argentina/Cordoba","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"ART","tzName":"Argentina Time"},{"zoneName":"America/Argentina/Jujuy","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"ART","tzName":"Argentina Time"},{"zoneName":"America/Argentina/La_Rioja","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"ART","tzName":"Argentina Time"},{"zoneName":"America/Argentina/Mendoza","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"ART","tzName":"Argentina Time"},{"zoneName":"America/Argentina/Rio_Gallegos","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"ART","tzName":"Argentina Time"},{"zoneName":"America/Argentina/Salta","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"ART","tzName":"Argentina Time"},{"zoneName":"America/Argentina/San_Juan","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"ART","tzName":"Argentina Time"},{"zoneName":"America/Argentina/San_Luis","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"ART","tzName":"Argentina Time"},{"zoneName":"America/Argentina/Tucuman","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"ART","tzName":"Argentina Time"},{"zoneName":"America/Argentina/Ushuaia","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"ART","tzName":"Argentina Time"}]',
        '{"ko":"아르헨티나","pt-BR":"Argentina","pt":"Argentina","nl":"Argentinië","hr":"Argentina","fa":"آرژانتین","de":"Argentinien","es":"Argentina","fr":"Argentine","ja":"アルゼンチン","it":"Argentina","zh-CN":"阿根廷","tr":"Arjantin","ru":"Аргентина","uk":"Аргентина","pl":"Argentyna"}',
        -34.00000000,
        -64.00000000,
        '🇦🇷',
        'U+1F1E6 U+1F1F7',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q414'
    );

INSERT INTO
    public.countries
VALUES
    (
        12,
        'Armenia',
        'ARM',
        '051',
        'AM',
        '374',
        'Yerevan',
        'AMD',
        'Armenian dram',
        '֏',
        '.am',
        'Հայաստան',
        'Asia',
        3,
        'Western Asia',
        11,
        'Armenian',
        '[{"zoneName":"Asia/Yerevan","gmtOffset":14400,"gmtOffsetName":"UTC+04:00","abbreviation":"AMT","tzName":"Armenia Time"}]',
        '{"ko":"아르메니아","pt-BR":"Armênia","pt":"Arménia","nl":"Armenië","hr":"Armenija","fa":"ارمنستان","de":"Armenien","es":"Armenia","fr":"Arménie","ja":"アルメニア","it":"Armenia","zh-CN":"亚美尼亚","tr":"Ermenistan","ru":"Армения","uk":"Вірменія","pl":"Armenia"}',
        40.00000000,
        45.00000000,
        '🇦🇲',
        'U+1F1E6 U+1F1F2',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q399'
    );

INSERT INTO
    public.countries
VALUES
    (
        13,
        'Aruba',
        'ABW',
        '533',
        'AW',
        '297',
        'Oranjestad',
        'AWG',
        'Aruban florin',
        'ƒ',
        '.aw',
        'Aruba',
        'Americas',
        2,
        'Caribbean',
        7,
        'Aruban',
        '[{"zoneName":"America/Aruba","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"아루바","pt-BR":"Aruba","pt":"Aruba","nl":"Aruba","hr":"Aruba","fa":"آروبا","de":"Aruba","es":"Aruba","fr":"Aruba","ja":"アルバ","it":"Aruba","zh-CN":"阿鲁巴","tr":"Aruba","ru":"Аруба","uk":"Аруба","pl":"Aruba"}',
        12.50000000,
        -69.96666666,
        '🇦🇼',
        'U+1F1E6 U+1F1FC',
        '2018-07-21 12:41:03',
        '2024-12-19 21:03:41',
        1,
        'Q21203'
    );

INSERT INTO
    public.countries
VALUES
    (
        14,
        'Australia',
        'AUS',
        '036',
        'AU',
        '61',
        'Canberra',
        'AUD',
        'Australian dollar',
        '$',
        '.au',
        'Australia',
        'Oceania',
        5,
        'Australia and New Zealand',
        19,
        'Australian',
        '[{"zoneName":"Antarctica/Macquarie","gmtOffset":39600,"gmtOffsetName":"UTC+11:00","abbreviation":"MIST","tzName":"Macquarie Island Station Time"},{"zoneName":"Australia/Adelaide","gmtOffset":37800,"gmtOffsetName":"UTC+10:30","abbreviation":"ACDT","tzName":"Australian Central Daylight Saving Time"},{"zoneName":"Australia/Brisbane","gmtOffset":36000,"gmtOffsetName":"UTC+10:00","abbreviation":"AEST","tzName":"Australian Eastern Standard Time"},{"zoneName":"Australia/Broken_Hill","gmtOffset":37800,"gmtOffsetName":"UTC+10:30","abbreviation":"ACDT","tzName":"Australian Central Daylight Saving Time"},{"zoneName":"Australia/Currie","gmtOffset":39600,"gmtOffsetName":"UTC+11:00","abbreviation":"AEDT","tzName":"Australian Eastern Daylight Saving Time"},{"zoneName":"Australia/Darwin","gmtOffset":34200,"gmtOffsetName":"UTC+09:30","abbreviation":"ACST","tzName":"Australian Central Standard Time"},{"zoneName":"Australia/Eucla","gmtOffset":31500,"gmtOffsetName":"UTC+08:45","abbreviation":"ACWST","tzName":"Australian Central Western Standard Time (Unofficial)"},{"zoneName":"Australia/Hobart","gmtOffset":39600,"gmtOffsetName":"UTC+11:00","abbreviation":"AEDT","tzName":"Australian Eastern Daylight Saving Time"},{"zoneName":"Australia/Lindeman","gmtOffset":36000,"gmtOffsetName":"UTC+10:00","abbreviation":"AEST","tzName":"Australian Eastern Standard Time"},{"zoneName":"Australia/Lord_Howe","gmtOffset":39600,"gmtOffsetName":"UTC+11:00","abbreviation":"LHST","tzName":"Lord Howe Summer Time"},{"zoneName":"Australia/Melbourne","gmtOffset":39600,"gmtOffsetName":"UTC+11:00","abbreviation":"AEDT","tzName":"Australian Eastern Daylight Saving Time"},{"zoneName":"Australia/Perth","gmtOffset":28800,"gmtOffsetName":"UTC+08:00","abbreviation":"AWST","tzName":"Australian Western Standard Time"},{"zoneName":"Australia/Sydney","gmtOffset":39600,"gmtOffsetName":"UTC+11:00","abbreviation":"AEDT","tzName":"Australian Eastern Daylight Saving Time"}]',
        '{"ko":"호주","pt-BR":"Austrália","pt":"Austrália","nl":"Australië","hr":"Australija","fa":"استرالیا","de":"Australien","es":"Australia","fr":"Australie","ja":"オーストラリア","it":"Australia","zh-CN":"澳大利亚","tr":"Avustralya","ru":"Австралия","uk":"Австралія","pl":"Australia"}',
        -27.00000000,
        133.00000000,
        '🇦🇺',
        'U+1F1E6 U+1F1FA',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q408'
    );

INSERT INTO
    public.countries
VALUES
    (
        15,
        'Austria',
        'AUT',
        '040',
        'AT',
        '43',
        'Vienna',
        'EUR',
        'Euro',
        '€',
        '.at',
        'Österreich',
        'Europe',
        4,
        'Western Europe',
        17,
        'Austrian',
        '[{"zoneName":"Europe/Vienna","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"오스트리아","pt-BR":"áustria","pt":"áustria","nl":"Oostenrijk","hr":"Austrija","fa":"اتریش","de":"Österreich","es":"Austria","fr":"Autriche","ja":"オーストリア","it":"Austria","zh-CN":"奥地利","tr":"Avusturya","ru":"Австрия","uk":"Австрія","pl":"Austria"}',
        47.33333333,
        13.33333333,
        '🇦🇹',
        'U+1F1E6 U+1F1F9',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q40'
    );

INSERT INTO
    public.countries
VALUES
    (
        16,
        'Azerbaijan',
        'AZE',
        '031',
        'AZ',
        '994',
        'Baku',
        'AZN',
        'Azerbaijani manat',
        'm',
        '.az',
        'Azərbaycan',
        'Asia',
        3,
        'Western Asia',
        11,
        'Azerbaijani, Azeri',
        '[{"zoneName":"Asia/Baku","gmtOffset":14400,"gmtOffsetName":"UTC+04:00","abbreviation":"AZT","tzName":"Azerbaijan Time"}]',
        '{"ko":"아제르바이잔","pt-BR":"Azerbaijão","pt":"Azerbaijão","nl":"Azerbeidzjan","hr":"Azerbajdžan","fa":"آذربایجان","de":"Aserbaidschan","es":"Azerbaiyán","fr":"Azerbaïdjan","ja":"アゼルバイジャン","it":"Azerbaijan","zh-CN":"阿塞拜疆","tr":"Azerbaycan","ru":"Азербайджан","uk":"Азербайджан","pl":"Azerbejdżan"}',
        40.50000000,
        47.50000000,
        '🇦🇿',
        'U+1F1E6 U+1F1FF',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q227'
    );

INSERT INTO
    public.countries
VALUES
    (
        17,
        'The Bahamas',
        'BHS',
        '044',
        'BS',
        '1',
        'Nassau',
        'BSD',
        'Bahamian dollar',
        'B$',
        '.bs',
        'Bahamas',
        'Americas',
        2,
        'Caribbean',
        7,
        'Bahamian',
        '[{"zoneName":"America/Nassau","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America)"}]',
        '{"ko":"바하마","pt-BR":"Bahamas","pt":"Baamas","nl":"Bahama’s","hr":"Bahami","fa":"باهاما","de":"Bahamas","es":"Bahamas","fr":"Bahamas","ja":"バハマ","it":"Bahamas","zh-CN":"巴哈马","tr":"Bahamalar","ru":"Багамы","uk":"Багамські острови","pl":"Bahamy"}',
        24.25000000,
        -76.00000000,
        '🇧🇸',
        'U+1F1E7 U+1F1F8',
        '2018-07-21 12:41:03',
        '2024-09-05 16:47:03',
        1,
        'Q778'
    );

INSERT INTO
    public.countries
VALUES
    (
        18,
        'Bahrain',
        'BHR',
        '048',
        'BH',
        '973',
        'Manama',
        'BHD',
        'Bahraini dinar',
        '.د.ب',
        '.bh',
        '‏البحرين',
        'Asia',
        3,
        'Western Asia',
        11,
        'Bahraini',
        '[{"zoneName":"Asia/Bahrain","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"AST","tzName":"Arabia Standard Time"}]',
        '{"ko":"바레인","pt-BR":"Bahrein","pt":"Barém","nl":"Bahrein","hr":"Bahrein","fa":"بحرین","de":"Bahrain","es":"Bahrein","fr":"Bahreïn","ja":"バーレーン","it":"Bahrein","zh-CN":"巴林","tr":"Bahreyn","ru":"Бахрейн","uk":"Бахрейн","pl":"Bahrajn"}',
        26.00000000,
        50.55000000,
        '🇧🇭',
        'U+1F1E7 U+1F1ED',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q398'
    );

INSERT INTO
    public.countries
VALUES
    (
        19,
        'Bangladesh',
        'BGD',
        '050',
        'BD',
        '880',
        'Dhaka',
        'BDT',
        'Bangladeshi taka',
        '৳',
        '.bd',
        'Bangladesh',
        'Asia',
        3,
        'Southern Asia',
        14,
        'Bangladeshi',
        '[{"zoneName":"Asia/Dhaka","gmtOffset":21600,"gmtOffsetName":"UTC+06:00","abbreviation":"BDT","tzName":"Bangladesh Standard Time"}]',
        '{"ko":"방글라데시","pt-BR":"Bangladesh","pt":"Bangladeche","nl":"Bangladesh","hr":"Bangladeš","fa":"بنگلادش","de":"Bangladesch","es":"Bangladesh","fr":"Bangladesh","ja":"バングラデシュ","it":"Bangladesh","zh-CN":"孟加拉","tr":"Bangladeş","ru":"Бангладеш","uk":"Бангладеш","pl":"Bangladesz"}',
        24.00000000,
        90.00000000,
        '🇧🇩',
        'U+1F1E7 U+1F1E9',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q902'
    );

INSERT INTO
    public.countries
VALUES
    (
        20,
        'Barbados',
        'BRB',
        '052',
        'BB',
        '1',
        'Bridgetown',
        'BBD',
        'Barbadian dollar',
        'Bds$',
        '.bb',
        'Barbados',
        'Americas',
        2,
        'Caribbean',
        7,
        'Barbadian',
        '[{"zoneName":"America/Barbados","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"바베이도스","pt-BR":"Barbados","pt":"Barbados","nl":"Barbados","hr":"Barbados","fa":"باربادوس","de":"Barbados","es":"Barbados","fr":"Barbade","ja":"バルバドス","it":"Barbados","zh-CN":"巴巴多斯","tr":"Barbados","ru":"Барбадос","uk":"Барбадос","pl":"Barbados"}',
        13.16666666,
        -59.53333333,
        '🇧🇧',
        'U+1F1E7 U+1F1E7',
        '2018-07-21 12:41:03',
        '2024-09-05 16:47:03',
        1,
        'Q244'
    );

INSERT INTO
    public.countries
VALUES
    (
        21,
        'Belarus',
        'BLR',
        '112',
        'BY',
        '375',
        'Minsk',
        'BYN',
        'Belarusian ruble',
        'Br',
        '.by',
        'Белару́сь',
        'Europe',
        4,
        'Eastern Europe',
        15,
        'Belarusian',
        '[{"zoneName":"Europe/Minsk","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"MSK","tzName":"Moscow Time"}]',
        '{"ko":"벨라루스","pt-BR":"Bielorrússia","pt":"Bielorrússia","nl":"Wit-Rusland","hr":"Bjelorusija","fa":"بلاروس","de":"Weißrussland","es":"Bielorrusia","fr":"Biélorussie","ja":"ベラルーシ","it":"Bielorussia","zh-CN":"白俄罗斯","tr":"Belarus","ru":"Беларусь","uk":"Білорусь","pl":"Białoruś"}',
        53.00000000,
        28.00000000,
        '🇧🇾',
        'U+1F1E7 U+1F1FE',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q184'
    );

INSERT INTO
    public.countries
VALUES
    (
        22,
        'Belgium',
        'BEL',
        '056',
        'BE',
        '32',
        'Brussels',
        'EUR',
        'Euro',
        '€',
        '.be',
        'België',
        'Europe',
        4,
        'Western Europe',
        17,
        'Belgian',
        '[{"zoneName":"Europe/Brussels","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"벨기에","pt-BR":"Bélgica","pt":"Bélgica","nl":"België","hr":"Belgija","fa":"بلژیک","de":"Belgien","es":"Bélgica","fr":"Belgique","ja":"ベルギー","it":"Belgio","zh-CN":"比利时","tr":"Belçika","ru":"Бельгия","uk":"Бельгія","pl":"Belgia"}',
        50.83333333,
        4.00000000,
        '🇧🇪',
        'U+1F1E7 U+1F1EA',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q31'
    );

INSERT INTO
    public.countries
VALUES
    (
        23,
        'Belize',
        'BLZ',
        '084',
        'BZ',
        '501',
        'Belmopan',
        'BZD',
        'Belize dollar',
        '$',
        '.bz',
        'Belize',
        'Americas',
        2,
        'Central America',
        9,
        'Belizean',
        '[{"zoneName":"America/Belize","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America)"}]',
        '{"ko":"벨리즈","pt-BR":"Belize","pt":"Belize","nl":"Belize","hr":"Belize","fa":"بلیز","de":"Belize","es":"Belice","fr":"Belize","ja":"ベリーズ","it":"Belize","zh-CN":"伯利兹","tr":"Belize","ru":"Белиз","uk":"Беліз","pl":"Belize"}',
        17.25000000,
        -88.75000000,
        '🇧🇿',
        'U+1F1E7 U+1F1FF',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q242'
    );

INSERT INTO
    public.countries
VALUES
    (
        24,
        'Benin',
        'BEN',
        '204',
        'BJ',
        '229',
        'Porto-Novo',
        'XOF',
        'West African CFA franc',
        'CFA',
        '.bj',
        'Bénin',
        'Africa',
        1,
        'Western Africa',
        3,
        'Beninese, Beninois',
        '[{"zoneName":"Africa/Porto-Novo","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"WAT","tzName":"West Africa Time"}]',
        '{"ko":"베냉","pt-BR":"Benin","pt":"Benim","nl":"Benin","hr":"Benin","fa":"بنین","de":"Benin","es":"Benín","fr":"Bénin","ja":"ベナン","it":"Benin","zh-CN":"贝宁","tr":"Benin","ru":"Бенин","uk":"Бенін","pl":"Benin"}',
        9.50000000,
        2.25000000,
        '🇧🇯',
        'U+1F1E7 U+1F1EF',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q962'
    );

INSERT INTO
    public.countries
VALUES
    (
        25,
        'Bermuda',
        'BMU',
        '060',
        'BM',
        '1',
        'Hamilton',
        'BMD',
        'Bermudian dollar',
        '$',
        '.bm',
        'Bermuda',
        'Americas',
        2,
        'Northern America',
        6,
        'Bermudian, Bermudan',
        '[{"zoneName":"Atlantic/Bermuda","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"버뮤다","pt-BR":"Bermudas","pt":"Bermudas","nl":"Bermuda","hr":"Bermudi","fa":"برمودا","de":"Bermuda","es":"Bermudas","fr":"Bermudes","ja":"バミューダ","it":"Bermuda","zh-CN":"百慕大","tr":"Bermuda","ru":"Бермуды","uk":"Бермудські острови","pl":"Bermudy"}',
        32.33333333,
        -64.75000000,
        '🇧🇲',
        'U+1F1E7 U+1F1F2',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q23635'
    );

INSERT INTO
    public.countries
VALUES
    (
        26,
        'Bhutan',
        'BTN',
        '064',
        'BT',
        '975',
        'Thimphu',
        'BTN',
        'Bhutanese ngultrum',
        'Nu.',
        '.bt',
        'ʼbrug-yul',
        'Asia',
        3,
        'Southern Asia',
        14,
        'Bhutanese',
        '[{"zoneName":"Asia/Thimphu","gmtOffset":21600,"gmtOffsetName":"UTC+06:00","abbreviation":"BTT","tzName":"Bhutan Time"}]',
        '{"ko":"부탄","pt-BR":"Butão","pt":"Butão","nl":"Bhutan","hr":"Butan","fa":"بوتان","de":"Bhutan","es":"Bután","fr":"Bhoutan","ja":"ブータン","it":"Bhutan","zh-CN":"不丹","tr":"Butan","ru":"Бутан","uk":"Бутан","pl":"Bhutan"}',
        27.50000000,
        90.50000000,
        '🇧🇹',
        'U+1F1E7 U+1F1F9',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q917'
    );

INSERT INTO
    public.countries
VALUES
    (
        27,
        'Bolivia',
        'BOL',
        '068',
        'BO',
        '591',
        'Sucre',
        'BOB',
        'Bolivian boliviano',
        'Bs.',
        '.bo',
        'Bolivia',
        'Americas',
        2,
        'South America',
        8,
        'Bolivian',
        '[{"zoneName":"America/La_Paz","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"BOT","tzName":"Bolivia Time"}]',
        '{"ko":"볼리비아","pt-BR":"Bolívia","pt":"Bolívia","nl":"Bolivia","hr":"Bolivija","fa":"بولیوی","de":"Bolivien","es":"Bolivia","fr":"Bolivie","ja":"ボリビア多民族国","it":"Bolivia","zh-CN":"玻利维亚","tr":"Bolivya","ru":"Боливия","uk":"Болівія","pl":"Boliwia"}',
        -17.00000000,
        -65.00000000,
        '🇧🇴',
        'U+1F1E7 U+1F1F4',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q750'
    );

INSERT INTO
    public.countries
VALUES
    (
        28,
        'Bosnia and Herzegovina',
        'BIH',
        '070',
        'BA',
        '387',
        'Sarajevo',
        'BAM',
        'Bosnia and Herzegovina convertible mark',
        'KM',
        '.ba',
        'Bosna i Hercegovina',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Bosnian or Herzegovinian',
        '[{"zoneName":"Europe/Sarajevo","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"보스니아 헤르체고비나","pt-BR":"Bósnia e Herzegovina","pt":"Bósnia e Herzegovina","nl":"Bosnië en Herzegovina","hr":"Bosna i Hercegovina","fa":"بوسنی و هرزگوین","de":"Bosnien und Herzegowina","es":"Bosnia y Herzegovina","fr":"Bosnie-Herzégovine","ja":"ボスニア・ヘルツェゴビナ","it":"Bosnia ed Erzegovina","zh-CN":"波斯尼亚和黑塞哥维那","tr":"Bosna Hersek","ru":"Босния и Герцеговина","uk":"Боснія і Герцеговина","pl":"Bośnia i Hercegowina"}',
        44.00000000,
        18.00000000,
        '🇧🇦',
        'U+1F1E7 U+1F1E6',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q225'
    );

INSERT INTO
    public.countries
VALUES
    (
        29,
        'Botswana',
        'BWA',
        '072',
        'BW',
        '267',
        'Gaborone',
        'BWP',
        'Botswana pula',
        'P',
        '.bw',
        'Botswana',
        'Africa',
        1,
        'Southern Africa',
        5,
        'Motswana, Botswanan',
        '[{"zoneName":"Africa/Gaborone","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"CAT","tzName":"Central Africa Time"}]',
        '{"ko":"보츠와나","pt-BR":"Botsuana","pt":"Botsuana","nl":"Botswana","hr":"Bocvana","fa":"بوتسوانا","de":"Botswana","es":"Botswana","fr":"Botswana","ja":"ボツワナ","it":"Botswana","zh-CN":"博茨瓦纳","tr":"Botsvana","ru":"Ботсвана","uk":"Ботсвана","pl":"Botswana"}',
        -22.00000000,
        24.00000000,
        '🇧🇼',
        'U+1F1E7 U+1F1FC',
        '2018-07-21 12:41:03',
        '2023-08-11 21:01:40',
        1,
        'Q963'
    );

INSERT INTO
    public.countries
VALUES
    (
        30,
        'Bouvet Island',
        'BVT',
        '074',
        'BV',
        '0055',
        '',
        'NOK',
        'Norwegian krone',
        'ko',
        '.bv',
        'Bouvetøya',
        '',
        NULL,
        '',
        NULL,
        'Bouvet Island',
        '[{"zoneName":"Europe/Oslo","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"부벳 섬","pt-BR":"Ilha Bouvet","pt":"Ilha Bouvet","nl":"Bouveteiland","hr":"Otok Bouvet","fa":"جزیره بووه","de":"Bouvetinsel","es":"Isla Bouvet","fr":"Île Bouvet","ja":"ブーベ島","it":"Isola Bouvet","zh-CN":"布维岛","tr":"Bouvet Adasi","ru":"Остров Буве","uk":"Острів Буве","pl":"Wyspa Bouveta"}',
        -54.43333333,
        3.40000000,
        '🇧🇻',
        'U+1F1E7 U+1F1FB',
        '2018-07-21 12:41:03',
        '2024-12-23 15:33:12',
        1,
        'Q23408'
    );

INSERT INTO
    public.countries
VALUES
    (
        31,
        'Brazil',
        'BRA',
        '076',
        'BR',
        '55',
        'Brasilia',
        'BRL',
        'Brazilian real',
        'R$',
        '.br',
        'Brasil',
        'Americas',
        2,
        'South America',
        8,
        'Brazilian',
        '[{"zoneName":"America/Araguaina","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"BRT","tzName":"Brasília Time"},{"zoneName":"America/Bahia","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"BRT","tzName":"Brasília Time"},{"zoneName":"America/Belem","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"BRT","tzName":"Brasília Time"},{"zoneName":"America/Boa_Vista","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AMT","tzName":"Amazon Time (Brazil)[3"},{"zoneName":"America/Campo_Grande","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AMT","tzName":"Amazon Time (Brazil)[3"},{"zoneName":"America/Cuiaba","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"BRT","tzName":"Brasilia Time"},{"zoneName":"America/Eirunepe","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"ACT","tzName":"Acre Time"},{"zoneName":"America/Fortaleza","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"BRT","tzName":"Brasília Time"},{"zoneName":"America/Maceio","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"BRT","tzName":"Brasília Time"},{"zoneName":"America/Manaus","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AMT","tzName":"Amazon Time (Brazil)"},{"zoneName":"America/Noronha","gmtOffset":-7200,"gmtOffsetName":"UTC-02:00","abbreviation":"FNT","tzName":"Fernando de Noronha Time"},{"zoneName":"America/Porto_Velho","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AMT","tzName":"Amazon Time (Brazil)[3"},{"zoneName":"America/Recife","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"BRT","tzName":"Brasília Time"},{"zoneName":"America/Rio_Branco","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"ACT","tzName":"Acre Time"},{"zoneName":"America/Santarem","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"BRT","tzName":"Brasília Time"},{"zoneName":"America/Sao_Paulo","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"BRT","tzName":"Brasília Time"}]',
        '{"ko":"브라질","pt-BR":"Brasil","pt":"Brasil","nl":"Brazilië","hr":"Brazil","fa":"برزیل","de":"Brasilien","es":"Brasil","fr":"Brésil","ja":"ブラジル","it":"Brasile","zh-CN":"巴西","tr":"Brezilya","ru":"Бразилия","uk":"Бразилія","pl":"Brazylia"}',
        -10.00000000,
        -55.00000000,
        '🇧🇷',
        'U+1F1E7 U+1F1F7',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q155'
    );

INSERT INTO
    public.countries
VALUES
    (
        32,
        'British Indian Ocean Territory',
        'IOT',
        '086',
        'IO',
        '246',
        'Diego Garcia',
        'USD',
        'United States dollar',
        '$',
        '.io',
        'British Indian Ocean Territory',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'BIOT',
        '[{"zoneName":"Indian/Chagos","gmtOffset":21600,"gmtOffsetName":"UTC+06:00","abbreviation":"IOT","tzName":"Indian Ocean Time"}]',
        '{"ko":"영국령 인도양 지역","pt-BR":"Território Britânico do Oceano íÍdico","pt":"Território Britânico do Oceano Índico","nl":"Britse Gebieden in de Indische Oceaan","hr":"Britanski Indijskooceanski teritorij","fa":"قلمرو بریتانیا در اقیانوس هند","de":"Britisches Territorium im Indischen Ozean","es":"Territorio Británico del Océano Índico","fr":"Territoire britannique de l''océan Indien","ja":"イギリス領インド洋地域","it":"Territorio britannico dell''oceano indiano","zh-CN":"英属印度洋领地","tr":"Britanya Hint Okyanusu Topraklari","ru":"Британская территория в Индийском океане","uk":"Британська територія в Індійському океані","pl":"Brytyjskie Terytorium Oceanu Indyjskiego"}',
        -6.00000000,
        71.50000000,
        '🇮🇴',
        'U+1F1EE U+1F1F4',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q43448'
    );

INSERT INTO
    public.countries
VALUES
    (
        33,
        'Brunei',
        'BRN',
        '096',
        'BN',
        '673',
        'Bandar Seri Begawan',
        'BND',
        'Brunei dollar',
        'B$',
        '.bn',
        'Negara Brunei Darussalam',
        'Asia',
        3,
        'South-Eastern Asia',
        13,
        'Bruneian',
        '[{"zoneName":"Asia/Brunei","gmtOffset":28800,"gmtOffsetName":"UTC+08:00","abbreviation":"BNT","tzName":"Brunei Darussalam Time"}]',
        '{"ko":"브루나이","pt-BR":"Brunei","pt":"Brunei","nl":"Brunei","hr":"Brunej","fa":"برونئی","de":"Brunei","es":"Brunei","fr":"Brunei","ja":"ブルネイ・ダルサラーム","it":"Brunei","zh-CN":"文莱","tr":"Brunei","ru":"Бруней","uk":"Бруней","pl":"Brunei"}',
        4.50000000,
        114.66666666,
        '🇧🇳',
        'U+1F1E7 U+1F1F3',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q921'
    );

INSERT INTO
    public.countries
VALUES
    (
        34,
        'Bulgaria',
        'BGR',
        '100',
        'BG',
        '359',
        'Sofia',
        'BGN',
        'Bulgarian lev',
        'Лв.',
        '.bg',
        'България',
        'Europe',
        4,
        'Eastern Europe',
        15,
        'Bulgarian',
        '[{"zoneName":"Europe/Sofia","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"불가리아","pt-BR":"Bulgária","pt":"Bulgária","nl":"Bulgarije","hr":"Bugarska","fa":"بلغارستان","de":"Bulgarien","es":"Bulgaria","fr":"Bulgarie","ja":"ブルガリア","it":"Bulgaria","zh-CN":"保加利亚","tr":"Bulgaristan","ru":"Болгария","uk":"Болгарія","pl":"Bułgaria"}',
        43.00000000,
        25.00000000,
        '🇧🇬',
        'U+1F1E7 U+1F1EC',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q219'
    );

INSERT INTO
    public.countries
VALUES
    (
        35,
        'Burkina Faso',
        'BFA',
        '854',
        'BF',
        '226',
        'Ouagadougou',
        'XOF',
        'West African CFA franc',
        'CFA',
        '.bf',
        'Burkina Faso',
        'Africa',
        1,
        'Western Africa',
        3,
        'Burkinabe',
        '[{"zoneName":"Africa/Ouagadougou","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"부르키나 파소","pt-BR":"Burkina Faso","pt":"Burquina Faso","nl":"Burkina Faso","hr":"Burkina Faso","fa":"بورکینافاسو","de":"Burkina Faso","es":"Burkina Faso","fr":"Burkina Faso","ja":"ブルキナファソ","it":"Burkina Faso","zh-CN":"布基纳法索","tr":"Burkina Faso","ru":"Буркина-Фасо","uk":"Буркіна-Фасо","pl":"Burkina Faso"}',
        13.00000000,
        -2.00000000,
        '🇧🇫',
        'U+1F1E7 U+1F1EB',
        '2018-07-21 12:41:03',
        '2023-08-11 21:15:55',
        1,
        'Q965'
    );

INSERT INTO
    public.countries
VALUES
    (
        36,
        'Burundi',
        'BDI',
        '108',
        'BI',
        '257',
        'Bujumbura',
        'BIF',
        'Burundian franc',
        'FBu',
        '.bi',
        'Burundi',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Burundian',
        '[{"zoneName":"Africa/Bujumbura","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"CAT","tzName":"Central Africa Time"}]',
        '{"ko":"부룬디","pt-BR":"Burundi","pt":"Burúndi","nl":"Burundi","hr":"Burundi","fa":"بوروندی","de":"Burundi","es":"Burundi","fr":"Burundi","ja":"ブルンジ","it":"Burundi","zh-CN":"布隆迪","tr":"Burundi","ru":"Бурунди","uk":"Бурунді","pl":"Burundi"}',
        -3.50000000,
        30.00000000,
        '🇧🇮',
        'U+1F1E7 U+1F1EE',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q967'
    );

INSERT INTO
    public.countries
VALUES
    (
        37,
        'Cambodia',
        'KHM',
        '116',
        'KH',
        '855',
        'Phnom Penh',
        'KHR',
        'Cambodian riel',
        'KHR',
        '.kh',
        'Kâmpŭchéa',
        'Asia',
        3,
        'South-Eastern Asia',
        13,
        'Cambodian',
        '[{"zoneName":"Asia/Phnom_Penh","gmtOffset":25200,"gmtOffsetName":"UTC+07:00","abbreviation":"ICT","tzName":"Indochina Time"}]',
        '{"ko":"캄보디아","pt-BR":"Camboja","pt":"Camboja","nl":"Cambodja","hr":"Kambodža","fa":"کامبوج","de":"Kambodscha","es":"Camboya","fr":"Cambodge","ja":"カンボジア","it":"Cambogia","zh-CN":"柬埔寨","tr":"Kamboçya","ru":"Камбоджа","uk":"Камбоджа","pl":"Kambodża"}',
        13.00000000,
        105.00000000,
        '🇰🇭',
        'U+1F1F0 U+1F1ED',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q424'
    );

INSERT INTO
    public.countries
VALUES
    (
        38,
        'Cameroon',
        'CMR',
        '120',
        'CM',
        '237',
        'Yaounde',
        'XAF',
        'Central African CFA franc',
        'FCFA',
        '.cm',
        'Cameroon',
        'Africa',
        1,
        'Middle Africa',
        2,
        'Cameroonian',
        '[{"zoneName":"Africa/Douala","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"WAT","tzName":"West Africa Time"}]',
        '{"ko":"카메룬","pt-BR":"Camarões","pt":"Camarões","nl":"Kameroen","hr":"Kamerun","fa":"کامرون","de":"Kamerun","es":"Camerún","fr":"Cameroun","ja":"カメルーン","it":"Camerun","zh-CN":"喀麦隆","tr":"Kamerun","ru":"Камерун","uk":"Камерун","pl":"Kamerun"}',
        6.00000000,
        12.00000000,
        '🇨🇲',
        'U+1F1E8 U+1F1F2',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q1009'
    );

INSERT INTO
    public.countries
VALUES
    (
        39,
        'Canada',
        'CAN',
        '124',
        'CA',
        '1',
        'Ottawa',
        'CAD',
        'Canadian dollar',
        '$',
        '.ca',
        'Canada',
        'Americas',
        2,
        'Northern America',
        6,
        'Canadian',
        '[{"zoneName":"America/Atikokan","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America)"},{"zoneName":"America/Blanc-Sablon","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"},{"zoneName":"America/Cambridge_Bay","gmtOffset":-25200,"gmtOffsetName":"UTC-07:00","abbreviation":"MST","tzName":"Mountain Standard Time (North America)"},{"zoneName":"America/Creston","gmtOffset":-25200,"gmtOffsetName":"UTC-07:00","abbreviation":"MST","tzName":"Mountain Standard Time (North America)"},{"zoneName":"America/Dawson","gmtOffset":-25200,"gmtOffsetName":"UTC-07:00","abbreviation":"MST","tzName":"Mountain Standard Time (North America)"},{"zoneName":"America/Dawson_Creek","gmtOffset":-25200,"gmtOffsetName":"UTC-07:00","abbreviation":"MST","tzName":"Mountain Standard Time (North America)"},{"zoneName":"America/Edmonton","gmtOffset":-25200,"gmtOffsetName":"UTC-07:00","abbreviation":"MST","tzName":"Mountain Standard Time (North America)"},{"zoneName":"America/Fort_Nelson","gmtOffset":-25200,"gmtOffsetName":"UTC-07:00","abbreviation":"MST","tzName":"Mountain Standard Time (North America)"},{"zoneName":"America/Glace_Bay","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"},{"zoneName":"America/Goose_Bay","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"},{"zoneName":"America/Halifax","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"},{"zoneName":"America/Inuvik","gmtOffset":-25200,"gmtOffsetName":"UTC-07:00","abbreviation":"MST","tzName":"Mountain Standard Time (North America"},{"zoneName":"America/Iqaluit","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"},{"zoneName":"America/Moncton","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"},{"zoneName":"America/Nipigon","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"},{"zoneName":"America/Pangnirtung","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"},{"zoneName":"America/Rainy_River","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/Rankin_Inlet","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/Regina","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/Resolute","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/St_Johns","gmtOffset":-12600,"gmtOffsetName":"UTC-03:30","abbreviation":"NST","tzName":"Newfoundland Standard Time"},{"zoneName":"America/Swift_Current","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/Thunder_Bay","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"},{"zoneName":"America/Toronto","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"},{"zoneName":"America/Vancouver","gmtOffset":-28800,"gmtOffsetName":"UTC-08:00","abbreviation":"PST","tzName":"Pacific Standard Time (North America"},{"zoneName":"America/Whitehorse","gmtOffset":-25200,"gmtOffsetName":"UTC-07:00","abbreviation":"MST","tzName":"Mountain Standard Time (North America"},{"zoneName":"America/Winnipeg","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/Yellowknife","gmtOffset":-25200,"gmtOffsetName":"UTC-07:00","abbreviation":"MST","tzName":"Mountain Standard Time (North America"}]',
        '{"ko":"캐나다","pt-BR":"Canadá","pt":"Canadá","nl":"Canada","hr":"Kanada","fa":"کانادا","de":"Kanada","es":"Canadá","fr":"Canada","ja":"カナダ","it":"Canada","zh-CN":"加拿大","tr":"Kanada","ru":"Канада","uk":"Канада","pl":"Kanada"}',
        60.00000000,
        -95.00000000,
        '🇨🇦',
        'U+1F1E8 U+1F1E6',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q16'
    );

INSERT INTO
    public.countries
VALUES
    (
        40,
        'Cape Verde',
        'CPV',
        '132',
        'CV',
        '238',
        'Praia',
        'CVE',
        'Cape Verdean escudo',
        '$',
        '.cv',
        'Cabo Verde',
        'Africa',
        1,
        'Western Africa',
        3,
        'Verdean',
        '[{"zoneName":"Atlantic/Cape_Verde","gmtOffset":-3600,"gmtOffsetName":"UTC-01:00","abbreviation":"CVT","tzName":"Cape Verde Time"}]',
        '{"ko":"카보베르데","pt-BR":"Cabo Verde","pt":"Cabo Verde","nl":"Kaapverdië","hr":"Zelenortska Republika","fa":"کیپ ورد","de":"Kap Verde","es":"Cabo Verde","fr":"Cap Vert","ja":"カーボベルデ","it":"Capo Verde","zh-CN":"佛得角","tr":"Cabo Verde","ru":"Кабо-Верде","uk":"Кабо-Верде","pl":"Republika Zielonego Przylądka"}',
        16.00000000,
        -24.00000000,
        '🇨🇻',
        'U+1F1E8 U+1F1FB',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q1011'
    );

INSERT INTO
    public.countries
VALUES
    (
        41,
        'Cayman Islands',
        'CYM',
        '136',
        'KY',
        '1',
        'George Town',
        'KYD',
        'Cayman Islands dollar',
        '$',
        '.ky',
        'Cayman Islands',
        'Americas',
        2,
        'Caribbean',
        7,
        'Caymanian',
        '[{"zoneName":"America/Cayman","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"}]',
        '{"ko":"케이먼 제도","pt-BR":"Ilhas Cayman","pt":"Ilhas Caimão","nl":"Caymaneilanden","hr":"Kajmanski otoci","fa":"جزایر کیمن","de":"Kaimaninseln","es":"Islas Caimán","fr":"Îles Caïmans","ja":"ケイマン諸島","it":"Isole Cayman","zh-CN":"开曼群岛","tr":"Cayman Adalari","ru":"Каймановы острова","uk":"Кайманові острови","pl":"Kajmany"}',
        19.50000000,
        -80.50000000,
        '🇰🇾',
        'U+1F1F0 U+1F1FE',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q5785'
    );

INSERT INTO
    public.countries
VALUES
    (
        42,
        'Central African Republic',
        'CAF',
        '140',
        'CF',
        '236',
        'Bangui',
        'XAF',
        'Central African CFA franc',
        'FCFA',
        '.cf',
        'Ködörösêse tî Bêafrîka',
        'Africa',
        1,
        'Middle Africa',
        2,
        'Central African',
        '[{"zoneName":"Africa/Bangui","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"WAT","tzName":"West Africa Time"}]',
        '{"ko":"중앙아프리카 공화국","pt-BR":"República Centro-Africana","pt":"República Centro-Africana","nl":"Centraal-Afrikaanse Republiek","hr":"Srednjoafrička Republika","fa":"جمهوری آفریقای مرکزی","de":"Zentralafrikanische Republik","es":"República Centroafricana","fr":"République centrafricaine","ja":"中央アフリカ共和国","it":"Repubblica Centrafricana","zh-CN":"中非","tr":"Orta Afrika Cumhuriyeti","ru":"Центральноафриканская Республика","uk":"Центральноафриканська Республіка","pl":"Republika Środkowoafrykańska"}',
        7.00000000,
        21.00000000,
        '🇨🇫',
        'U+1F1E8 U+1F1EB',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q929'
    );

INSERT INTO
    public.countries
VALUES
    (
        43,
        'Chad',
        'TCD',
        '148',
        'TD',
        '235',
        'N''Djamena',
        'XAF',
        'Central African CFA franc',
        'FCFA',
        '.td',
        'Tchad',
        'Africa',
        1,
        'Middle Africa',
        2,
        'Chadian',
        '[{"zoneName":"Africa/Ndjamena","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"WAT","tzName":"West Africa Time"}]',
        '{"ko":"차드","pt-BR":"Chade","pt":"Chade","nl":"Tsjaad","hr":"Čad","fa":"چاد","de":"Tschad","es":"Chad","fr":"Tchad","ja":"チャド","it":"Ciad","zh-CN":"乍得","tr":"Çad","ru":"Чад","uk":"Чад.","pl":"Czad"}',
        15.00000000,
        19.00000000,
        '🇹🇩',
        'U+1F1F9 U+1F1E9',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q657'
    );

INSERT INTO
    public.countries
VALUES
    (
        44,
        'Chile',
        'CHL',
        '152',
        'CL',
        '56',
        'Santiago',
        'CLP',
        'Chilean peso',
        '$',
        '.cl',
        'Chile',
        'Americas',
        2,
        'South America',
        8,
        'Chilean',
        '[{"zoneName":"America/Punta_Arenas","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"CLST","tzName":"Chile Summer Time"},{"zoneName":"America/Santiago","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"CLST","tzName":"Chile Summer Time"},{"zoneName":"Pacific/Easter","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EASST","tzName":"Easter Island Summer Time"}]',
        '{"ko":"칠리","pt-BR":"Chile","pt":"Chile","nl":"Chili","hr":"Čile","fa":"شیلی","de":"Chile","es":"Chile","fr":"Chili","ja":"チリ","it":"Cile","zh-CN":"智利","tr":"Şili","ru":"Чили","uk":"Чилі","pl":"Chile"}',
        -30.00000000,
        -71.00000000,
        '🇨🇱',
        'U+1F1E8 U+1F1F1',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q298'
    );

INSERT INTO
    public.countries
VALUES
    (
        45,
        'China',
        'CHN',
        '156',
        'CN',
        '86',
        'Beijing',
        'CNY',
        'Chinese yuan',
        '¥',
        '.cn',
        '中国',
        'Asia',
        3,
        'Eastern Asia',
        12,
        'Chinese',
        '[{"zoneName":"Asia/Shanghai","gmtOffset":28800,"gmtOffsetName":"UTC+08:00","abbreviation":"CST","tzName":"China Standard Time"},{"zoneName":"Asia/Urumqi","gmtOffset":21600,"gmtOffsetName":"UTC+06:00","abbreviation":"XJT","tzName":"China Standard Time"}]',
        '{"ko":"중국","pt-BR":"China","pt":"China","nl":"China","hr":"Kina","fa":"چین","de":"China","es":"China","fr":"Chine","ja":"中国","it":"Cina","zh-CN":"中国","tr":"Çin","ru":"Китай","uk":"Китай","pl":"Chiny"}',
        35.00000000,
        105.00000000,
        '🇨🇳',
        'U+1F1E8 U+1F1F3',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q148'
    );

INSERT INTO
    public.countries
VALUES
    (
        46,
        'Christmas Island',
        'CXR',
        '162',
        'CX',
        '61',
        'Flying Fish Cove',
        'AUD',
        'Australian dollar',
        '$',
        '.cx',
        'Christmas Island',
        'Oceania',
        5,
        'Australia and New Zealand',
        19,
        'Christmas Island',
        '[{"zoneName":"Indian/Christmas","gmtOffset":25200,"gmtOffsetName":"UTC+07:00","abbreviation":"CXT","tzName":"Christmas Island Time"}]',
        '{"ko":"크리스마스 섬","pt-BR":"Ilha Christmas","pt":"Ilha do Natal","nl":"Christmaseiland","hr":"Božićni otok","fa":"جزیره کریسمس","de":"Weihnachtsinsel","es":"Isla de Navidad","fr":"Île Christmas","ja":"クリスマス島","it":"Isola di Natale","zh-CN":"圣诞岛","tr":"Christmas Adasi","ru":"Остров Рождества","uk":"Острів Різдва","pl":"Wyspa Bożego Narodzenia"}',
        -10.50000000,
        105.66666666,
        '🇨🇽',
        'U+1F1E8 U+1F1FD',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q31063'
    );

INSERT INTO
    public.countries
VALUES
    (
        47,
        'Cocos (Keeling) Islands',
        'CCK',
        '166',
        'CC',
        '61',
        'West Island',
        'AUD',
        'Australian dollar',
        '$',
        '.cc',
        'Cocos (Keeling) Islands',
        'Oceania',
        5,
        'Australia and New Zealand',
        19,
        'Cocos Island',
        '[{"zoneName":"Indian/Cocos","gmtOffset":23400,"gmtOffsetName":"UTC+06:30","abbreviation":"CCT","tzName":"Cocos Islands Time"}]',
        '{"ko":"코코스 제도","pt-BR":"Ilhas Cocos","pt":"Ilhas dos Cocos","nl":"Cocoseilanden","hr":"Kokosovi Otoci","fa":"جزایر کوکوس","de":"Kokosinseln","es":"Islas Cocos o Islas Keeling","fr":"Îles Cocos","ja":"ココス（キーリング）諸島","it":"Isole Cocos e Keeling","zh-CN":"科科斯（基林）群岛","tr":"Cocos Adalari","ru":"Кокосовые (Килинг) острова","uk":"Кокосові (Кілінг) острови","pl":"Wyspy Kokosowe (Keelinga)"}',
        -12.50000000,
        96.83333333,
        '🇨🇨',
        'U+1F1E8 U+1F1E8',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q36004'
    );

INSERT INTO
    public.countries
VALUES
    (
        48,
        'Colombia',
        'COL',
        '170',
        'CO',
        '57',
        'Bogotá',
        'COP',
        'Colombian peso',
        '$',
        '.co',
        'Colombia',
        'Americas',
        2,
        'South America',
        8,
        'Colombian',
        '[{"zoneName":"America/Bogota","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"COT","tzName":"Colombia Time"}]',
        '{"ko":"콜롬비아","pt-BR":"Colômbia","pt":"Colômbia","nl":"Colombia","hr":"Kolumbija","fa":"کلمبیا","de":"Kolumbien","es":"Colombia","fr":"Colombie","ja":"コロンビア","it":"Colombia","zh-CN":"哥伦比亚","tr":"Kolombiya","ru":"Колумбия","uk":"Колумбія","pl":"Kolumbia"}',
        4.00000000,
        -72.00000000,
        '🇨🇴',
        'U+1F1E8 U+1F1F4',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q739'
    );

INSERT INTO
    public.countries
VALUES
    (
        49,
        'Comoros',
        'COM',
        '174',
        'KM',
        '269',
        'Moroni',
        'KMF',
        'Comorian franc',
        'CF',
        '.km',
        'Komori',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Comoran, Comorian',
        '[{"zoneName":"Indian/Comoro","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"EAT","tzName":"East Africa Time"}]',
        '{"ko":"코모로","pt-BR":"Comores","pt":"Comores","nl":"Comoren","hr":"Komori","fa":"کومور","de":"Union der Komoren","es":"Comoras","fr":"Comores","ja":"コモロ","it":"Comore","zh-CN":"科摩罗","tr":"Komorlar","ru":"Коморские острова","uk":"Коморські острови","pl":"Komory"}',
        -12.16666666,
        44.25000000,
        '🇰🇲',
        'U+1F1F0 U+1F1F2',
        '2018-07-21 12:41:03',
        '2023-08-11 21:15:55',
        1,
        'Q970'
    );

INSERT INTO
    public.countries
VALUES
    (
        50,
        'Congo',
        'COG',
        '178',
        'CG',
        '242',
        'Brazzaville',
        'XAF',
        'Congolese Franc',
        'CDF',
        '.cg',
        'République du Congo',
        'Africa',
        1,
        'Middle Africa',
        2,
        'Congolese',
        '[{"zoneName":"Africa/Brazzaville","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"WAT","tzName":"West Africa Time"}]',
        '{"ko":"콩고","pt-BR":"Congo","pt":"Congo","nl":"Congo [Republiek]","hr":"Kongo","fa":"کنگو","de":"Kongo","es":"Congo","fr":"Congo","ja":"コンゴ共和国","it":"Congo","zh-CN":"刚果","tr":"Kongo","ru":"Конго","uk":"Конго","pl":"Kongo"}',
        -1.00000000,
        15.00000000,
        '🇨🇬',
        'U+1F1E8 U+1F1EC',
        '2018-07-21 12:41:03',
        '2024-12-23 15:55:22',
        1,
        'Q971'
    );

INSERT INTO
    public.countries
VALUES
    (
        51,
        'Democratic Republic of the Congo',
        'COD',
        '180',
        'CD',
        '243',
        'Kinshasa',
        'CDF',
        'Congolese Franc',
        'FC',
        '.cd',
        'République démocratique du Congo',
        'Africa',
        1,
        'Middle Africa',
        2,
        'Congolese',
        '[{"zoneName":"Africa/Kinshasa","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"WAT","tzName":"West Africa Time"},{"zoneName":"Africa/Lubumbashi","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"CAT","tzName":"Central Africa Time"}]',
        '{"ko":"콩고 민주 공화국","pt-BR":"RD Congo","pt":"RD Congo","nl":"Congo [DRC]","hr":"Kongo, Demokratska Republika","fa":"جمهوری کنگو","de":"Kongo (Dem. Rep.)","es":"Congo (Rep. Dem.)","fr":"Congo (Rép. dém.)","ja":"コンゴ民主共和国","it":"Congo (Rep. Dem.)","zh-CN":"刚果（金）","tr":"Kongo Demokratik Cumhuriyeti","ru":"Демократическая Республика Конго","uk":"Демократична Республіка Конго","pl":"Demokratyczna Republika Konga"}',
        0.00000000,
        25.00000000,
        '🇨🇩',
        'U+1F1E8 U+1F1E9',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q974'
    );

INSERT INTO
    public.countries
VALUES
    (
        52,
        'Cook Islands',
        'COK',
        '184',
        'CK',
        '682',
        'Avarua',
        'NZD',
        'New Zealand dollar',
        '$',
        '.ck',
        'Cook Islands',
        'Oceania',
        5,
        'Polynesia',
        22,
        'Cook Island',
        '[{"zoneName":"Pacific/Rarotonga","gmtOffset":-36000,"gmtOffsetName":"UTC-10:00","abbreviation":"CKT","tzName":"Cook Island Time"}]',
        '{"ko":"쿡 제도","pt-BR":"Ilhas Cook","pt":"Ilhas Cook","nl":"Cookeilanden","hr":"Cookovo Otočje","fa":"جزایر کوک","de":"Cookinseln","es":"Islas Cook","fr":"Îles Cook","ja":"クック諸島","it":"Isole Cook","zh-CN":"库克群岛","tr":"Cook Adalari","ru":"Острова Кука","uk":"Острови Кука","pl":"Wyspy Cooka"}',
        -21.23333333,
        -159.76666666,
        '🇨🇰',
        'U+1F1E8 U+1F1F0',
        '2018-07-21 12:41:03',
        '2024-12-23 15:33:12',
        1,
        'Q26988'
    );

INSERT INTO
    public.countries
VALUES
    (
        53,
        'Costa Rica',
        'CRI',
        '188',
        'CR',
        '506',
        'San Jose',
        'CRC',
        'Costa Rican colón',
        '₡',
        '.cr',
        'Costa Rica',
        'Americas',
        2,
        'Central America',
        9,
        'Costa Rican',
        '[{"zoneName":"America/Costa_Rica","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"}]',
        '{"ko":"코스타리카","pt-BR":"Costa Rica","pt":"Costa Rica","nl":"Costa Rica","hr":"Kostarika","fa":"کاستاریکا","de":"Costa Rica","es":"Costa Rica","fr":"Costa Rica","ja":"コスタリカ","it":"Costa Rica","zh-CN":"哥斯达黎加","tr":"Kosta Rika","ru":"Коста-Рика","uk":"Коста-Ріка","pl":"Kostaryka"}',
        10.00000000,
        -84.00000000,
        '🇨🇷',
        'U+1F1E8 U+1F1F7',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q800'
    );

INSERT INTO
    public.countries
VALUES
    (
        54,
        'Cote D''Ivoire (Ivory Coast)',
        'CIV',
        '384',
        'CI',
        '225',
        'Yamoussoukro',
        'XOF',
        'West African CFA franc',
        'CFA',
        '.ci',
        NULL,
        'Africa',
        1,
        'Western Africa',
        3,
        'Ivorian',
        '[{"zoneName":"Africa/Abidjan","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"코트디부아르","pt-BR":"Costa do Marfim","pt":"Costa do Marfim","nl":"Ivoorkust","hr":"Obala Bjelokosti","fa":"ساحل عاج","de":"Elfenbeinküste","es":"Costa de Marfil","fr":"Côte d''Ivoire","ja":"コートジボワール","it":"Costa D''Avorio","zh-CN":"科特迪瓦","tr":"Kotdivuar","ru":"Кот-д''Ивуар (Берег Слоновой Кости)","uk":"Кот-д''Івуар (Берег Слонової Кістки)","pl":"Cote D''Ivoire (Wybrzeże Kości Słoniowej)"}',
        8.00000000,
        -5.00000000,
        '🇨🇮',
        'U+1F1E8 U+1F1EE',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q1008'
    );

INSERT INTO
    public.countries
VALUES
    (
        55,
        'Croatia',
        'HRV',
        '191',
        'HR',
        '385',
        'Zagreb',
        'EUR',
        'Euro',
        '€',
        '.hr',
        'Hrvatska',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Croatian',
        '[{"zoneName":"Europe/Zagreb","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"크로아티아","pt-BR":"Croácia","pt":"Croácia","nl":"Kroatië","hr":"Hrvatska","fa":"کرواسی","de":"Kroatien","es":"Croacia","fr":"Croatie","ja":"クロアチア","it":"Croazia","zh-CN":"克罗地亚","tr":"Hirvatistan","ru":"Хорватия","uk":"Хорватія","pl":"Chorwacja"}',
        45.16666666,
        15.50000000,
        '🇭🇷',
        'U+1F1ED U+1F1F7',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q224'
    );

INSERT INTO
    public.countries
VALUES
    (
        56,
        'Cuba',
        'CUB',
        '192',
        'CU',
        '53',
        'Havana',
        'CUP',
        'Cuban peso',
        '$',
        '.cu',
        'Cuba',
        'Americas',
        2,
        'Caribbean',
        7,
        'Cuban',
        '[{"zoneName":"America/Havana","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"CST","tzName":"Cuba Standard Time"}]',
        '{"ko":"쿠바","pt-BR":"Cuba","pt":"Cuba","nl":"Cuba","hr":"Kuba","fa":"کوبا","de":"Kuba","es":"Cuba","fr":"Cuba","ja":"キューバ","it":"Cuba","zh-CN":"古巴","tr":"Küba","ru":"Куба","uk":"Куба","pl":"Kuba"}',
        21.50000000,
        -80.00000000,
        '🇨🇺',
        'U+1F1E8 U+1F1FA',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q241'
    );

INSERT INTO
    public.countries
VALUES
    (
        57,
        'Cyprus',
        'CYP',
        '196',
        'CY',
        '357',
        'Nicosia',
        'EUR',
        'Euro',
        '€',
        '.cy',
        'Κύπρος',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Cypriot',
        '[{"zoneName":"Asia/Famagusta","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"},{"zoneName":"Asia/Nicosia","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"키프로스","pt-BR":"Chipre","pt":"Chipre","nl":"Cyprus","hr":"Cipar","fa":"قبرس","de":"Zypern","es":"Chipre","fr":"Chypre","ja":"キプロス","it":"Cipro","zh-CN":"塞浦路斯","tr":"Kuzey Kıbrıs Türk Cumhuriyeti","ru":"Кипр","uk":"Кіпр","pl":"Cypr"}',
        35.00000000,
        33.00000000,
        '🇨🇾',
        'U+1F1E8 U+1F1FE',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q229'
    );

INSERT INTO
    public.countries
VALUES
    (
        58,
        'Czech Republic',
        'CZE',
        '203',
        'CZ',
        '420',
        'Prague',
        'CZK',
        'Czech koruna',
        'Kč',
        '.cz',
        'Česká republika',
        'Europe',
        4,
        'Eastern Europe',
        15,
        'Czech',
        '[{"zoneName":"Europe/Prague","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"체코","pt-BR":"República Tcheca","pt":"República Checa","nl":"Tsjechië","hr":"Češka","fa":"جمهوری چک","de":"Tschechische Republik","es":"República Checa","fr":"République tchèque","ja":"チェコ","it":"Repubblica Ceca","zh-CN":"捷克","tr":"Çekya","ru":"Чешская Республика","uk":"Чеська Республіка","pl":"Republika Czeska"}',
        49.75000000,
        15.50000000,
        '🇨🇿',
        'U+1F1E8 U+1F1FF',
        '2018-07-21 12:41:03',
        '2024-09-05 17:11:18',
        1,
        'Q213'
    );

INSERT INTO
    public.countries
VALUES
    (
        59,
        'Denmark',
        'DNK',
        '208',
        'DK',
        '45',
        'Copenhagen',
        'DKK',
        'Danish krone',
        'Kr.',
        '.dk',
        'Danmark',
        'Europe',
        4,
        'Northern Europe',
        18,
        'Danish',
        '[{"zoneName":"Europe/Copenhagen","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"덴마크","pt-BR":"Dinamarca","pt":"Dinamarca","nl":"Denemarken","hr":"Danska","fa":"دانمارک","de":"Dänemark","es":"Dinamarca","fr":"Danemark","ja":"デンマーク","it":"Danimarca","zh-CN":"丹麦","tr":"Danimarka","ru":"Дания","uk":"Данія","pl":"Dania"}',
        56.00000000,
        10.00000000,
        '🇩🇰',
        'U+1F1E9 U+1F1F0',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q35'
    );

INSERT INTO
    public.countries
VALUES
    (
        60,
        'Djibouti',
        'DJI',
        '262',
        'DJ',
        '253',
        'Djibouti',
        'DJF',
        'Djiboutian franc',
        'Fdj',
        '.dj',
        'Djibouti',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Djiboutian',
        '[{"zoneName":"Africa/Djibouti","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"EAT","tzName":"East Africa Time"}]',
        '{"ko":"지부티","pt-BR":"Djibuti","pt":"Djibuti","nl":"Djibouti","hr":"Džibuti","fa":"جیبوتی","de":"Dschibuti","es":"Yibuti","fr":"Djibouti","ja":"ジブチ","it":"Gibuti","zh-CN":"吉布提","tr":"Cibuti","ru":"Джибути","uk":"Джибуті","pl":"Dżibuti"}',
        11.50000000,
        43.00000000,
        '🇩🇯',
        'U+1F1E9 U+1F1EF',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q977'
    );

INSERT INTO
    public.countries
VALUES
    (
        61,
        'Dominica',
        'DMA',
        '212',
        'DM',
        '1',
        'Roseau',
        'XCD',
        'Eastern Caribbean dollar',
        '$',
        '.dm',
        'Dominica',
        'Americas',
        2,
        'Caribbean',
        7,
        'Dominican',
        '[{"zoneName":"America/Dominica","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"도미니카 연방","pt-BR":"Dominica","pt":"Dominica","nl":"Dominica","hr":"Dominika","fa":"دومینیکا","de":"Dominica","es":"Dominica","fr":"Dominique","ja":"ドミニカ国","it":"Dominica","zh-CN":"多米尼加","tr":"Dominika","ru":"Доминика","uk":"Домініка","pl":"Dominika"}',
        15.41666666,
        -61.33333333,
        '🇩🇲',
        'U+1F1E9 U+1F1F2',
        '2018-07-21 12:41:03',
        '2024-09-05 16:47:03',
        1,
        'Q784'
    );

INSERT INTO
    public.countries
VALUES
    (
        62,
        'Dominican Republic',
        'DOM',
        '214',
        'DO',
        '1',
        'Santo Domingo',
        'DOP',
        'Dominican peso',
        '$',
        '.do',
        'República Dominicana',
        'Americas',
        2,
        'Caribbean',
        7,
        'Dominican',
        '[{"zoneName":"America/Santo_Domingo","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"도미니카 공화국","pt-BR":"República Dominicana","pt":"República Dominicana","nl":"Dominicaanse Republiek","hr":"Dominikanska Republika","fa":"جمهوری دومینیکن","de":"Dominikanische Republik","es":"República Dominicana","fr":"République dominicaine","ja":"ドミニカ共和国","it":"Repubblica Dominicana","zh-CN":"多明尼加共和国","tr":"Dominik Cumhuriyeti","ru":"Доминиканская Республика","uk":"Домініканська Республіка","pl":"Republika Dominikańska"}',
        19.00000000,
        -70.66666666,
        '🇩🇴',
        'U+1F1E9 U+1F1F4',
        '2018-07-21 12:41:03',
        '2024-09-05 16:47:03',
        1,
        'Q786'
    );

INSERT INTO
    public.countries
VALUES
    (
        63,
        'Timor-Leste',
        'TLS',
        '626',
        'TL',
        '670',
        'Dili',
        'USD',
        'United States dollar',
        '$',
        '.tl',
        'Timor-Leste',
        'Asia',
        3,
        'South-Eastern Asia',
        13,
        'Timorese',
        '[{"zoneName":"Asia/Dili","gmtOffset":32400,"gmtOffsetName":"UTC+09:00","abbreviation":"TLT","tzName":"Timor Leste Time"}]',
        '{"ko":"동티모르","pt-BR":"Timor Leste","pt":"Timor Leste","nl":"Oost-Timor","hr":"Istočni Timor","fa":"تیمور شرقی","de":"Timor-Leste","es":"Timor Oriental","fr":"Timor oriental","ja":"東ティモール","it":"Timor Est","zh-CN":"东帝汶","tr":"Doğu Timor","ru":"Тимор-Лешти","uk":"Тимор-Лешті","pl":"Timor Wschodni"}',
        -8.83333333,
        125.91666666,
        '🇹🇱',
        'U+1F1F9 U+1F1F1',
        '2018-07-21 12:41:03',
        '2023-08-11 21:15:55',
        1,
        'Q574'
    );

INSERT INTO
    public.countries
VALUES
    (
        64,
        'Ecuador',
        'ECU',
        '218',
        'EC',
        '593',
        'Quito',
        'USD',
        'United States dollar',
        '$',
        '.ec',
        'Ecuador',
        'Americas',
        2,
        'South America',
        8,
        'Ecuadorian',
        '[{"zoneName":"America/Guayaquil","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"ECT","tzName":"Ecuador Time"},{"zoneName":"Pacific/Galapagos","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"GALT","tzName":"Galápagos Time"}]',
        '{"ko":"에콰도르","pt-BR":"Equador","pt":"Equador","nl":"Ecuador","hr":"Ekvador","fa":"اکوادور","de":"Ecuador","es":"Ecuador","fr":"Équateur","ja":"エクアドル","it":"Ecuador","zh-CN":"厄瓜多尔","tr":"Ekvator","ru":"Эквадор","uk":"Еквадор","pl":"Ekwador"}',
        -2.00000000,
        -77.50000000,
        '🇪🇨',
        'U+1F1EA U+1F1E8',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q736'
    );

INSERT INTO
    public.countries
VALUES
    (
        65,
        'Egypt',
        'EGY',
        '818',
        'EG',
        '20',
        'Cairo',
        'EGP',
        'Egyptian pound',
        'ج.م',
        '.eg',
        'مصر‎',
        'Africa',
        1,
        'Northern Africa',
        1,
        'Egyptian',
        '[{"zoneName":"Africa/Cairo","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"이집트","pt-BR":"Egito","pt":"Egipto","nl":"Egypte","hr":"Egipat","fa":"مصر","de":"Ägypten","es":"Egipto","fr":"Égypte","ja":"エジプト","it":"Egitto","zh-CN":"埃及","tr":"Mısır","ru":"Египет","uk":"Єгипет","pl":"Egipt"}',
        27.00000000,
        30.00000000,
        '🇪🇬',
        'U+1F1EA U+1F1EC',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q79'
    );

INSERT INTO
    public.countries
VALUES
    (
        66,
        'El Salvador',
        'SLV',
        '222',
        'SV',
        '503',
        'San Salvador',
        'USD',
        'United States dollar',
        '$',
        '.sv',
        'El Salvador',
        'Americas',
        2,
        'Central America',
        9,
        'Salvadoran',
        '[{"zoneName":"America/El_Salvador","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"}]',
        '{"ko":"엘살바도르","pt-BR":"El Salvador","pt":"El Salvador","nl":"El Salvador","hr":"Salvador","fa":"السالوادور","de":"El Salvador","es":"El Salvador","fr":"Salvador","ja":"エルサルバドル","it":"El Salvador","zh-CN":"萨尔瓦多","tr":"El Salvador","ru":"Сальвадор","uk":"Сальвадор","pl":"Salwador"}',
        13.83333333,
        -88.91666666,
        '🇸🇻',
        'U+1F1F8 U+1F1FB',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q792'
    );

INSERT INTO
    public.countries
VALUES
    (
        67,
        'Equatorial Guinea',
        'GNQ',
        '226',
        'GQ',
        '240',
        'Malabo',
        'XAF',
        'Central African CFA franc',
        'FCFA',
        '.gq',
        'Guinea Ecuatorial',
        'Africa',
        1,
        'Middle Africa',
        2,
        'Equatorial Guinean, Equatoguinean',
        '[{"zoneName":"Africa/Malabo","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"WAT","tzName":"West Africa Time"}]',
        '{"ko":"적도 기니","pt-BR":"Guiné Equatorial","pt":"Guiné Equatorial","nl":"Equatoriaal-Guinea","hr":"Ekvatorijalna Gvineja","fa":"گینه استوایی","de":"Äquatorial-Guinea","es":"Guinea Ecuatorial","fr":"Guinée-Équatoriale","ja":"赤道ギニア","it":"Guinea Equatoriale","zh-CN":"赤道几内亚","tr":"Ekvator Ginesi","ru":"Экваториальная Гвинея","uk":"Екваторіальна Гвінея","pl":"Gwinea Równikowa"}',
        2.00000000,
        10.00000000,
        '🇬🇶',
        'U+1F1EC U+1F1F6',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q983'
    );

INSERT INTO
    public.countries
VALUES
    (
        68,
        'Eritrea',
        'ERI',
        '232',
        'ER',
        '291',
        'Asmara',
        'ERN',
        'Eritrean nakfa',
        'Nfk',
        '.er',
        'ኤርትራ',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Eritrean',
        '[{"zoneName":"Africa/Asmara","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"EAT","tzName":"East Africa Time"}]',
        '{"ko":"에리트레아","pt-BR":"Eritreia","pt":"Eritreia","nl":"Eritrea","hr":"Eritreja","fa":"اریتره","de":"Eritrea","es":"Eritrea","fr":"Érythrée","ja":"エリトリア","it":"Eritrea","zh-CN":"厄立特里亚","tr":"Eritre","ru":"Эритрея","uk":"Еритрея","pl":"Erytrea"}',
        15.00000000,
        39.00000000,
        '🇪🇷',
        'U+1F1EA U+1F1F7',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q986'
    );

INSERT INTO
    public.countries
VALUES
    (
        69,
        'Estonia',
        'EST',
        '233',
        'EE',
        '372',
        'Tallinn',
        'EUR',
        'Euro',
        '€',
        '.ee',
        'Eesti',
        'Europe',
        4,
        'Northern Europe',
        18,
        'Estonian',
        '[{"zoneName":"Europe/Tallinn","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"에스토니아","pt-BR":"Estônia","pt":"Estónia","nl":"Estland","hr":"Estonija","fa":"استونی","de":"Estland","es":"Estonia","fr":"Estonie","ja":"エストニア","it":"Estonia","zh-CN":"爱沙尼亚","tr":"Estonya","ru":"Эстония","uk":"Естонія","pl":"Estonia"}',
        59.00000000,
        26.00000000,
        '🇪🇪',
        'U+1F1EA U+1F1EA',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q191'
    );

INSERT INTO
    public.countries
VALUES
    (
        70,
        'Ethiopia',
        'ETH',
        '231',
        'ET',
        '251',
        'Addis Ababa',
        'ETB',
        'Ethiopian birr',
        'Nkf',
        '.et',
        'ኢትዮጵያ',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Ethiopian',
        '[{"zoneName":"Africa/Addis_Ababa","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"EAT","tzName":"East Africa Time"}]',
        '{"ko":"에티오피아","pt-BR":"Etiópia","pt":"Etiópia","nl":"Ethiopië","hr":"Etiopija","fa":"اتیوپی","de":"Äthiopien","es":"Etiopía","fr":"Éthiopie","ja":"エチオピア","it":"Etiopia","zh-CN":"埃塞俄比亚","tr":"Etiyopya","ru":"Эфиопия","uk":"Ефіопія","pl":"Etiopia"}',
        8.00000000,
        38.00000000,
        '🇪🇹',
        'U+1F1EA U+1F1F9',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q115'
    );

INSERT INTO
    public.countries
VALUES
    (
        71,
        'Falkland Islands',
        'FLK',
        '238',
        'FK',
        '500',
        'Stanley',
        'FKP',
        'Falkland Islands pound',
        '£',
        '.fk',
        'Falkland Islands',
        'Americas',
        2,
        'South America',
        8,
        'Falkland Island',
        '[{"zoneName":"Atlantic/Stanley","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"FKST","tzName":"Falkland Islands Summer Time"}]',
        '{"ko":"포클랜드 제도","pt-BR":"Ilhas Malvinas","pt":"Ilhas Falkland","nl":"Falklandeilanden [Islas Malvinas]","hr":"Falklandski Otoci","fa":"جزایر فالکلند","de":"Falklandinseln","es":"Islas Malvinas","fr":"Îles Malouines","ja":"フォークランド（マルビナス）諸島","it":"Isole Falkland o Isole Malvine","zh-CN":"福克兰群岛","tr":"Falkland Adalari","ru":"Фолклендские острова","uk":"Фолклендські острови","pl":"Falklandy"}',
        -51.75000000,
        -59.00000000,
        '🇫🇰',
        'U+1F1EB U+1F1F0',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q9648'
    );

INSERT INTO
    public.countries
VALUES
    (
        72,
        'Faroe Islands',
        'FRO',
        '234',
        'FO',
        '298',
        'Torshavn',
        'DKK',
        'Danish krone',
        'Kr.',
        '.fo',
        'Føroyar',
        'Europe',
        4,
        'Northern Europe',
        18,
        'Faroese',
        '[{"zoneName":"Atlantic/Faroe","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"WET","tzName":"Western European Time"}]',
        '{"ko":"페로 제도","pt-BR":"Ilhas Faroé","pt":"Ilhas Faroé","nl":"Faeröer","hr":"Farski Otoci","fa":"جزایر فارو","de":"Färöer-Inseln","es":"Islas Faroe","fr":"Îles Féroé","ja":"フェロー諸島","it":"Isole Far Oer","zh-CN":"法罗群岛","tr":"Faroe Adalari","ru":"Фарерские острова","uk":"Фарерські острови","pl":"Wyspy Owcze"}',
        62.00000000,
        -7.00000000,
        '🇫🇴',
        'U+1F1EB U+1F1F4',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q4628'
    );

INSERT INTO
    public.countries
VALUES
    (
        73,
        'Fiji Islands',
        'FJI',
        '242',
        'FJ',
        '679',
        'Suva',
        'FJD',
        'Fijian dollar',
        'FJ$',
        '.fj',
        'Fiji',
        'Oceania',
        5,
        'Melanesia',
        20,
        'Fijian',
        '[{"zoneName":"Pacific/Fiji","gmtOffset":43200,"gmtOffsetName":"UTC+12:00","abbreviation":"FJT","tzName":"Fiji Time"}]',
        '{"ko":"피지","pt-BR":"Fiji","pt":"Fiji","nl":"Fiji","hr":"Fiđi","fa":"فیجی","de":"Fidschi","es":"Fiyi","fr":"Fidji","ja":"フィジー","it":"Figi","zh-CN":"斐济","tr":"Fiji","ru":"Острова Фиджи","uk":"Острови Фіджі","pl":"Wyspy Fidżi"}',
        -18.00000000,
        175.00000000,
        '🇫🇯',
        'U+1F1EB U+1F1EF',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q712'
    );

INSERT INTO
    public.countries
VALUES
    (
        75,
        'France',
        'FRA',
        '250',
        'FR',
        '33',
        'Paris',
        'EUR',
        'Euro',
        '€',
        '.fr',
        'France',
        'Europe',
        4,
        'Western Europe',
        17,
        'French',
        '[{"zoneName":"Europe/Paris","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"프랑스","pt-BR":"França","pt":"França","nl":"Frankrijk","hr":"Francuska","fa":"فرانسه","de":"Frankreich","es":"Francia","fr":"France","ja":"フランス","it":"Francia","zh-CN":"法国","tr":"Fransa","ru":"Франция","uk":"Франція","pl":"Francja"}',
        46.00000000,
        2.00000000,
        '🇫🇷',
        'U+1F1EB U+1F1F7',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q142'
    );

INSERT INTO
    public.countries
VALUES
    (
        76,
        'French Guiana',
        'GUF',
        '254',
        'GF',
        '594',
        'Cayenne',
        'EUR',
        'Euro',
        '€',
        '.gf',
        'Guyane française',
        'Americas',
        2,
        'South America',
        8,
        'French Guianese',
        '[{"zoneName":"America/Cayenne","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"GFT","tzName":"French Guiana Time"}]',
        '{"ko":"프랑스령 기아나","pt-BR":"Guiana Francesa","pt":"Guiana Francesa","nl":"Frans-Guyana","hr":"Francuska Gvajana","fa":"گویان فرانسه","de":"Französisch Guyana","es":"Guayana Francesa","fr":"Guayane","ja":"フランス領ギアナ","it":"Guyana francese","zh-CN":"法属圭亚那","tr":"Fransiz Guyanasi","ru":"Французская Гвиана","uk":"Французька Гвіана","pl":"Gujana Francuska"}',
        4.00000000,
        -53.00000000,
        '🇬🇫',
        'U+1F1EC U+1F1EB',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q3769'
    );

INSERT INTO
    public.countries
VALUES
    (
        77,
        'French Polynesia',
        'PYF',
        '258',
        'PF',
        '689',
        'Papeete',
        'XPF',
        'CFP franc',
        '₣',
        '.pf',
        'Polynésie française',
        'Oceania',
        5,
        'Polynesia',
        22,
        'French Polynesia',
        '[{"zoneName":"Pacific/Gambier","gmtOffset":-32400,"gmtOffsetName":"UTC-09:00","abbreviation":"GAMT","tzName":"Gambier Islands Time"},{"zoneName":"Pacific/Marquesas","gmtOffset":-34200,"gmtOffsetName":"UTC-09:30","abbreviation":"MART","tzName":"Marquesas Islands Time"},{"zoneName":"Pacific/Tahiti","gmtOffset":-36000,"gmtOffsetName":"UTC-10:00","abbreviation":"TAHT","tzName":"Tahiti Time"}]',
        '{"ko":"프랑스령 폴리네시아","pt-BR":"Polinésia Francesa","pt":"Polinésia Francesa","nl":"Frans-Polynesië","hr":"Francuska Polinezija","fa":"پلی‌نزی فرانسه","de":"Französisch-Polynesien","es":"Polinesia Francesa","fr":"Polynésie française","ja":"フランス領ポリネシア","it":"Polinesia Francese","zh-CN":"法属波利尼西亚","tr":"Fransiz Polinezyasi","ru":"Французская Полинезия","uk":"Французька Полінезія","pl":"Polinezja Francuska"}',
        -15.00000000,
        -140.00000000,
        '🇵🇫',
        'U+1F1F5 U+1F1EB',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q30971'
    );

INSERT INTO
    public.countries
VALUES
    (
        78,
        'French Southern Territories',
        'ATF',
        '260',
        'TF',
        '262',
        'Port-aux-Francais',
        'EUR',
        'Euro',
        '€',
        '.tf',
        'Territoire des Terres australes et antarctiques fr',
        'Africa',
        1,
        'Southern Africa',
        5,
        'French Southern Territories',
        '[{"zoneName":"Indian/Kerguelen","gmtOffset":18000,"gmtOffsetName":"UTC+05:00","abbreviation":"TFT","tzName":"French Southern and Antarctic Time"}]',
        '{"ko":"프랑스령 남방 및 남극","pt-BR":"Terras Austrais e Antárticas Francesas","pt":"Terras Austrais e Antárticas Francesas","nl":"Franse Gebieden in de zuidelijke Indische Oceaan","hr":"Francuski južni i antarktički teritoriji","fa":"سرزمین‌های جنوبی و جنوبگانی فرانسه","de":"Französische Süd- und Antarktisgebiete","es":"Tierras Australes y Antárticas Francesas","fr":"Terres australes et antarctiques françaises","ja":"フランス領南方・南極地域","it":"Territori Francesi del Sud","zh-CN":"法属南部领地","tr":"Fransiz Güney Topraklari","ru":"Французские южные территории","uk":"Французькі південні території","pl":"Francuskie terytoria południowe"}',
        -49.25000000,
        69.16700000,
        '🇹🇫',
        'U+1F1F9 U+1F1EB',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q129003'
    );

INSERT INTO
    public.countries
VALUES
    (
        79,
        'Gabon',
        'GAB',
        '266',
        'GA',
        '241',
        'Libreville',
        'XAF',
        'Central African CFA franc',
        'FCFA',
        '.ga',
        'Gabon',
        'Africa',
        1,
        'Middle Africa',
        2,
        'Gabonese',
        '[{"zoneName":"Africa/Libreville","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"WAT","tzName":"West Africa Time"}]',
        '{"ko":"가봉","pt-BR":"Gabão","pt":"Gabão","nl":"Gabon","hr":"Gabon","fa":"گابن","de":"Gabun","es":"Gabón","fr":"Gabon","ja":"ガボン","it":"Gabon","zh-CN":"加蓬","tr":"Gabon","ru":"Габон","uk":"Габон","pl":"Gabon"}',
        -1.00000000,
        11.75000000,
        '🇬🇦',
        'U+1F1EC U+1F1E6',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q1000'
    );

INSERT INTO
    public.countries
VALUES
    (
        80,
        'The Gambia ',
        'GMB',
        '270',
        'GM',
        '220',
        'Banjul',
        'GMD',
        'Gambian dalasi',
        'D',
        '.gm',
        'Gambia',
        'Africa',
        1,
        'Western Africa',
        3,
        'Gambian',
        '[{"zoneName":"Africa/Banjul","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"감비아","pt-BR":"Gâmbia","pt":"Gâmbia","nl":"Gambia","hr":"Gambija","fa":"گامبیا","de":"Gambia","es":"Gambia","fr":"Gambie","ja":"ガンビア","it":"Gambia","zh-CN":"冈比亚","tr":"Gambiya","ru":"Гамбия","uk":"Гамбія The","pl":"Gambia The"}',
        13.46666666,
        -16.56666666,
        '🇬🇲',
        'U+1F1EC U+1F1F2',
        '2018-07-21 12:41:03',
        '2024-09-03 16:53:28',
        1,
        'Q1005'
    );

INSERT INTO
    public.countries
VALUES
    (
        81,
        'Georgia',
        'GEO',
        '268',
        'GE',
        '995',
        'Tbilisi',
        'GEL',
        'Georgian lari',
        'ლ',
        '.ge',
        'საქართველო',
        'Asia',
        3,
        'Western Asia',
        11,
        'Georgian',
        '[{"zoneName":"Asia/Tbilisi","gmtOffset":14400,"gmtOffsetName":"UTC+04:00","abbreviation":"GET","tzName":"Georgia Standard Time"}]',
        '{"ko":"조지아","pt-BR":"Geórgia","pt":"Geórgia","nl":"Georgië","hr":"Gruzija","fa":"گرجستان","de":"Georgien","es":"Georgia","fr":"Géorgie","ja":"グルジア","it":"Georgia","zh-CN":"格鲁吉亚","tr":"Gürcistan","ru":"Джорджия","uk":"Грузія","pl":"Gruzja"}',
        42.00000000,
        43.50000000,
        '🇬🇪',
        'U+1F1EC U+1F1EA',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q230'
    );

INSERT INTO
    public.countries
VALUES
    (
        82,
        'Germany',
        'DEU',
        '276',
        'DE',
        '49',
        'Berlin',
        'EUR',
        'Euro',
        '€',
        '.de',
        'Deutschland',
        'Europe',
        4,
        'Western Europe',
        17,
        'German',
        '[{"zoneName":"Europe/Berlin","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"},{"zoneName":"Europe/Busingen","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"독일","pt-BR":"Alemanha","pt":"Alemanha","nl":"Duitsland","hr":"Njemačka","fa":"آلمان","de":"Deutschland","es":"Alemania","fr":"Allemagne","ja":"ドイツ","it":"Germania","zh-CN":"德国","tr":"Almanya","ru":"Германия","uk":"Німеччина","pl":"Niemcy"}',
        51.00000000,
        9.00000000,
        '🇩🇪',
        'U+1F1E9 U+1F1EA',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q183'
    );

INSERT INTO
    public.countries
VALUES
    (
        83,
        'Ghana',
        'GHA',
        '288',
        'GH',
        '233',
        'Accra',
        'GHS',
        'Ghanaian cedi',
        'GH₵',
        '.gh',
        'Ghana',
        'Africa',
        1,
        'Western Africa',
        3,
        'Ghanaian',
        '[{"zoneName":"Africa/Accra","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"가나","pt-BR":"Gana","pt":"Gana","nl":"Ghana","hr":"Gana","fa":"غنا","de":"Ghana","es":"Ghana","fr":"Ghana","ja":"ガーナ","it":"Ghana","zh-CN":"加纳","tr":"Gana","ru":"Гана","uk":"Гана","pl":"Ghana"}',
        8.00000000,
        -2.00000000,
        '🇬🇭',
        'U+1F1EC U+1F1ED',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q117'
    );

INSERT INTO
    public.countries
VALUES
    (
        84,
        'Gibraltar',
        'GIB',
        '292',
        'GI',
        '350',
        'Gibraltar',
        'GIP',
        'Gibraltar pound',
        '£',
        '.gi',
        'Gibraltar',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Gibraltar',
        '[{"zoneName":"Europe/Gibraltar","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"지브롤터","pt-BR":"Gibraltar","pt":"Gibraltar","nl":"Gibraltar","hr":"Gibraltar","fa":"جبل‌طارق","de":"Gibraltar","es":"Gibraltar","fr":"Gibraltar","ja":"ジブラルタル","it":"Gibilterra","zh-CN":"直布罗陀","tr":"Cebelitarik","ru":"Гибралтар","uk":"Гібралтар","pl":"Gibraltar"}',
        36.13333333,
        -5.35000000,
        '🇬🇮',
        'U+1F1EC U+1F1EE',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q1410'
    );

INSERT INTO
    public.countries
VALUES
    (
        85,
        'Greece',
        'GRC',
        '300',
        'GR',
        '30',
        'Athens',
        'EUR',
        'Euro',
        '€',
        '.gr',
        'Ελλάδα',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Greek, Hellenic',
        '[{"zoneName":"Europe/Athens","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"그리스","pt-BR":"Grécia","pt":"Grécia","nl":"Griekenland","hr":"Grčka","fa":"یونان","de":"Griechenland","es":"Grecia","fr":"Grèce","ja":"ギリシャ","it":"Grecia","zh-CN":"希腊","tr":"Yunanistan","ru":"Греция","uk":"Греція","pl":"Grecja"}',
        39.00000000,
        22.00000000,
        '🇬🇷',
        'U+1F1EC U+1F1F7',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q41'
    );

INSERT INTO
    public.countries
VALUES
    (
        86,
        'Greenland',
        'GRL',
        '304',
        'GL',
        '299',
        'Nuuk',
        'DKK',
        'Danish krone',
        'Kr.',
        '.gl',
        'Kalaallit Nunaat',
        'Americas',
        2,
        'Northern America',
        6,
        'Greenlandic',
        '[{"zoneName":"America/Danmarkshavn","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"},{"zoneName":"America/Nuuk","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"WGT","tzName":"West Greenland Time"},{"zoneName":"America/Scoresbysund","gmtOffset":-3600,"gmtOffsetName":"UTC-01:00","abbreviation":"EGT","tzName":"Eastern Greenland Time"},{"zoneName":"America/Thule","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"그린란드","pt-BR":"Groelândia","pt":"Gronelândia","nl":"Groenland","hr":"Grenland","fa":"گرینلند","de":"Grönland","es":"Groenlandia","fr":"Groenland","ja":"グリーンランド","it":"Groenlandia","zh-CN":"格陵兰岛","tr":"Grönland","ru":"Гренландия","uk":"Гренландія","pl":"Grenlandia"}',
        72.00000000,
        -40.00000000,
        '🇬🇱',
        'U+1F1EC U+1F1F1',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q223'
    );

INSERT INTO
    public.countries
VALUES
    (
        87,
        'Grenada',
        'GRD',
        '308',
        'GD',
        '1',
        'St. George''s',
        'XCD',
        'Eastern Caribbean dollar',
        '$',
        '.gd',
        'Grenada',
        'Americas',
        2,
        'Caribbean',
        7,
        'Grenadian',
        '[{"zoneName":"America/Grenada","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"그레나다","pt-BR":"Granada","pt":"Granada","nl":"Grenada","hr":"Grenada","fa":"گرنادا","de":"Grenada","es":"Grenada","fr":"Grenade","ja":"グレナダ","it":"Grenada","zh-CN":"格林纳达","tr":"Grenada","ru":"Гренада","uk":"Гренада","pl":"Grenada"}',
        12.11666666,
        -61.66666666,
        '🇬🇩',
        'U+1F1EC U+1F1E9',
        '2018-07-21 12:41:03',
        '2024-09-05 16:47:03',
        1,
        'Q769'
    );

INSERT INTO
    public.countries
VALUES
    (
        88,
        'Guadeloupe',
        'GLP',
        '312',
        'GP',
        '590',
        'Basse-Terre',
        'EUR',
        'Euro',
        '€',
        '.gp',
        'Guadeloupe',
        'Americas',
        2,
        'Caribbean',
        7,
        'Guadeloupe',
        '[{"zoneName":"America/Guadeloupe","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"과들루프","pt-BR":"Guadalupe","pt":"Guadalupe","nl":"Guadeloupe","hr":"Gvadalupa","fa":"جزیره گوادلوپ","de":"Guadeloupe","es":"Guadalupe","fr":"Guadeloupe","ja":"グアドループ","it":"Guadeloupa","zh-CN":"瓜德罗普岛","tr":"Guadeloupe","ru":"Гваделупа","uk":"Гваделупа","pl":"Gwadelupa"}',
        16.25000000,
        -61.58333300,
        '🇬🇵',
        'U+1F1EC U+1F1F5',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q17012'
    );

INSERT INTO
    public.countries
VALUES
    (
        89,
        'Guam',
        'GUM',
        '316',
        'GU',
        '1',
        'Hagatna',
        'USD',
        'United States dollar',
        '$',
        '.gu',
        'Guam',
        'Oceania',
        5,
        'Micronesia',
        21,
        'Guamanian, Guambat',
        '[{"zoneName":"Pacific/Guam","gmtOffset":36000,"gmtOffsetName":"UTC+10:00","abbreviation":"CHST","tzName":"Chamorro Standard Time"}]',
        '{"ko":"괌","pt-BR":"Guam","pt":"Guame","nl":"Guam","hr":"Guam","fa":"گوام","de":"Guam","es":"Guam","fr":"Guam","ja":"グアム","it":"Guam","zh-CN":"关岛","tr":"Guam","ru":"Гуам","uk":"Гуам","pl":"Guam"}',
        13.46666666,
        144.78333333,
        '🇬🇺',
        'U+1F1EC U+1F1FA',
        '2018-07-21 12:41:03',
        '2024-12-23 15:33:12',
        1,
        'Q16635'
    );

INSERT INTO
    public.countries
VALUES
    (
        90,
        'Guatemala',
        'GTM',
        '320',
        'GT',
        '502',
        'Guatemala City',
        'GTQ',
        'Guatemalan quetzal',
        'Q',
        '.gt',
        'Guatemala',
        'Americas',
        2,
        'Central America',
        9,
        'Guatemalan',
        '[{"zoneName":"America/Guatemala","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"}]',
        '{"ko":"과테말라","pt-BR":"Guatemala","pt":"Guatemala","nl":"Guatemala","hr":"Gvatemala","fa":"گواتمالا","de":"Guatemala","es":"Guatemala","fr":"Guatemala","ja":"グアテマラ","it":"Guatemala","zh-CN":"危地马拉","tr":"Guatemala","ru":"Гватемала","uk":"Гватемала","pl":"Gwatemala"}',
        15.50000000,
        -90.25000000,
        '🇬🇹',
        'U+1F1EC U+1F1F9',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q774'
    );

INSERT INTO
    public.countries
VALUES
    (
        91,
        'Guernsey',
        'GGY',
        '831',
        'GG',
        '44',
        'St Peter Port',
        'GBP',
        'British pound',
        '£',
        '.gg',
        'Guernsey',
        'Europe',
        4,
        'Northern Europe',
        18,
        'Channel Island',
        '[{"zoneName":"Europe/Guernsey","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"건지, 올더니","pt-BR":"Guernsey","pt":"Guernsey","nl":"Guernsey","hr":"Guernsey","fa":"گرنزی","de":"Guernsey","es":"Guernsey","fr":"Guernesey","ja":"ガーンジー","it":"Guernsey","zh-CN":"根西岛","tr":"Alderney","ru":"Гернси и Олдерни","uk":"Гернсі та Олдерні","pl":"Guernsey i Alderney"}',
        49.46666666,
        -2.58333333,
        '🇬🇬',
        'U+1F1EC U+1F1EC',
        '2018-07-21 12:41:03',
        '2025-03-29 13:35:03',
        1,
        NULL
    );

INSERT INTO
    public.countries
VALUES
    (
        92,
        'Guinea',
        'GIN',
        '324',
        'GN',
        '224',
        'Conakry',
        'GNF',
        'Guinean franc',
        'FG',
        '.gn',
        'Guinée',
        'Africa',
        1,
        'Western Africa',
        3,
        'Guinean',
        '[{"zoneName":"Africa/Conakry","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"기니","pt-BR":"Guiné","pt":"Guiné","nl":"Guinee","hr":"Gvineja","fa":"گینه","de":"Guinea","es":"Guinea","fr":"Guinée","ja":"ギニア","it":"Guinea","zh-CN":"几内亚","tr":"Gine","ru":"Гвинея","uk":"Гвінея","pl":"Gwinea"}',
        11.00000000,
        -10.00000000,
        '🇬🇳',
        'U+1F1EC U+1F1F3',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q1006'
    );

INSERT INTO
    public.countries
VALUES
    (
        93,
        'Guinea-Bissau',
        'GNB',
        '624',
        'GW',
        '245',
        'Bissau',
        'XOF',
        'West African CFA franc',
        'CFA',
        '.gw',
        'Guiné-Bissau',
        'Africa',
        1,
        'Western Africa',
        3,
        'Bissau-Guinean',
        '[{"zoneName":"Africa/Bissau","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"기니비사우","pt-BR":"Guiné-Bissau","pt":"Guiné-Bissau","nl":"Guinee-Bissau","hr":"Gvineja Bisau","fa":"گینه بیسائو","de":"Guinea-Bissau","es":"Guinea-Bisáu","fr":"Guinée-Bissau","ja":"ギニアビサウ","it":"Guinea-Bissau","zh-CN":"几内亚比绍","tr":"Gine-bissau","ru":"Гвинея-Бисау","uk":"Гвінея-Бісау","pl":"Gwinea Bissau"}',
        12.00000000,
        -15.00000000,
        '🇬🇼',
        'U+1F1EC U+1F1FC',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q1007'
    );

INSERT INTO
    public.countries
VALUES
    (
        94,
        'Guyana',
        'GUY',
        '328',
        'GY',
        '592',
        'Georgetown',
        'GYD',
        'Guyanese dollar',
        '$',
        '.gy',
        'Guyana',
        'Americas',
        2,
        'South America',
        8,
        'Guyanese',
        '[{"zoneName":"America/Guyana","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"GYT","tzName":"Guyana Time"}]',
        '{"ko":"가이아나","pt-BR":"Guiana","pt":"Guiana","nl":"Guyana","hr":"Gvajana","fa":"گویان","de":"Guyana","es":"Guyana","fr":"Guyane","ja":"ガイアナ","it":"Guyana","zh-CN":"圭亚那","tr":"Guyana","ru":"Гайана","uk":"Гайана","pl":"Gujana"}',
        5.00000000,
        -59.00000000,
        '🇬🇾',
        'U+1F1EC U+1F1FE',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q734'
    );

INSERT INTO
    public.countries
VALUES
    (
        95,
        'Haiti',
        'HTI',
        '332',
        'HT',
        '509',
        'Port-au-Prince',
        'HTG',
        'Haitian gourde',
        'G',
        '.ht',
        'Haïti',
        'Americas',
        2,
        'Caribbean',
        7,
        'Haitian',
        '[{"zoneName":"America/Port-au-Prince","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"}]',
        '{"ko":"아이티","pt-BR":"Haiti","pt":"Haiti","nl":"Haïti","hr":"Haiti","fa":"هائیتی","de":"Haiti","es":"Haiti","fr":"Haïti","ja":"ハイチ","it":"Haiti","zh-CN":"海地","tr":"Haiti","ru":"Гаити","uk":"Гаїті","pl":"Haiti"}',
        19.00000000,
        -72.41666666,
        '🇭🇹',
        'U+1F1ED U+1F1F9',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q790'
    );

INSERT INTO
    public.countries
VALUES
    (
        96,
        'Heard Island and McDonald Islands',
        'HMD',
        '334',
        'HM',
        '672',
        '',
        'AUD',
        'Australian dollar',
        '$',
        '.hm',
        'Heard Island and McDonald Islands',
        '',
        NULL,
        '',
        NULL,
        'Heard Island or McDonald Islands',
        '[{"zoneName":"Indian/Kerguelen","gmtOffset":18000,"gmtOffsetName":"UTC+05:00","abbreviation":"TFT","tzName":"French Southern and Antarctic Time"}]',
        '{"ko":"허드 맥도날드 제도","pt-BR":"Ilha Heard e Ilhas McDonald","pt":"Ilha Heard e Ilhas McDonald","nl":"Heard- en McDonaldeilanden","hr":"Otok Heard i otočje McDonald","fa":"جزیره هرد و جزایر مک‌دونالد","de":"Heard und die McDonaldinseln","es":"Islas Heard y McDonald","fr":"Îles Heard-et-MacDonald","ja":"ハード島とマクドナルド諸島","it":"Isole Heard e McDonald","zh-CN":"赫德·唐纳岛及麦唐纳岛","tr":"Heard Adasi Ve Mcdonald Adalari","ru":"Остров Херд и острова Макдональд","uk":"Острів Херд та острови Макдональд","pl":"Wyspa Heard i Wyspy McDonalda"}',
        -53.10000000,
        72.51666666,
        '🇭🇲',
        'U+1F1ED U+1F1F2',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q131198'
    );

INSERT INTO
    public.countries
VALUES
    (
        97,
        'Honduras',
        'HND',
        '340',
        'HN',
        '504',
        'Tegucigalpa',
        'HNL',
        'Honduran lempira',
        'L',
        '.hn',
        'Honduras',
        'Americas',
        2,
        'Central America',
        9,
        'Honduran',
        '[{"zoneName":"America/Tegucigalpa","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"}]',
        '{"ko":"온두라스","pt-BR":"Honduras","pt":"Honduras","nl":"Honduras","hr":"Honduras","fa":"هندوراس","de":"Honduras","es":"Honduras","fr":"Honduras","ja":"ホンジュラス","it":"Honduras","zh-CN":"洪都拉斯","tr":"Honduras","ru":"Гондурас","uk":"Гондурас","pl":"Honduras"}',
        15.00000000,
        -86.50000000,
        '🇭🇳',
        'U+1F1ED U+1F1F3',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q783'
    );

INSERT INTO
    public.countries
VALUES
    (
        98,
        'Hong Kong S.A.R.',
        'HKG',
        '344',
        'HK',
        '852',
        'Hong Kong',
        'HKD',
        'Hong Kong dollar',
        '$',
        '.hk',
        '香港',
        'Asia',
        3,
        'Eastern Asia',
        12,
        'Hong Kong, Hong Kongese',
        '[{"zoneName":"Asia/Hong_Kong","gmtOffset":28800,"gmtOffsetName":"UTC+08:00","abbreviation":"HKT","tzName":"Hong Kong Time"}]',
        '{"ko":"홍콩","pt-BR":"Hong Kong","pt":"Hong Kong","nl":"Hongkong","hr":"Hong Kong","fa":"هنگ‌کنگ","de":"Hong Kong","es":"Hong Kong","fr":"Hong Kong","ja":"香港","it":"Hong Kong","zh-CN":"中国香港","tr":"Hong Kong","ru":"Гонконг С.А.Р.","uk":"Гонконг САР.","pl":"Hongkong S.A.R."}',
        22.25000000,
        114.16666666,
        '🇭🇰',
        'U+1F1ED U+1F1F0',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q8646'
    );

INSERT INTO
    public.countries
VALUES
    (
        99,
        'Hungary',
        'HUN',
        '348',
        'HU',
        '36',
        'Budapest',
        'HUF',
        'Hungarian forint',
        'Ft',
        '.hu',
        'Magyarország',
        'Europe',
        4,
        'Eastern Europe',
        15,
        'Hungarian, Magyar',
        '[{"zoneName":"Europe/Budapest","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"헝가리","pt-BR":"Hungria","pt":"Hungria","nl":"Hongarije","hr":"Mađarska","fa":"مجارستان","de":"Ungarn","es":"Hungría","fr":"Hongrie","ja":"ハンガリー","it":"Ungheria","zh-CN":"匈牙利","tr":"Macaristan","ru":"Венгрия","uk":"Угорщина","pl":"Węgry"}',
        47.00000000,
        20.00000000,
        '🇭🇺',
        'U+1F1ED U+1F1FA',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q28'
    );

INSERT INTO
    public.countries
VALUES
    (
        100,
        'Iceland',
        'ISL',
        '352',
        'IS',
        '354',
        'Reykjavik',
        'ISK',
        'Icelandic króna',
        'ko',
        '.is',
        'Ísland',
        'Europe',
        4,
        'Northern Europe',
        18,
        'Icelandic',
        '[{"zoneName":"Atlantic/Reykjavik","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"아이슬란드","pt-BR":"Islândia","pt":"Islândia","nl":"IJsland","hr":"Island","fa":"ایسلند","de":"Island","es":"Islandia","fr":"Islande","ja":"アイスランド","it":"Islanda","zh-CN":"冰岛","tr":"İzlanda","ru":"Исландия","uk":"Ісландія","pl":"Islandia"}',
        65.00000000,
        -18.00000000,
        '🇮🇸',
        'U+1F1EE U+1F1F8',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q189'
    );

INSERT INTO
    public.countries
VALUES
    (
        101,
        'India',
        'IND',
        '356',
        'IN',
        '91',
        'New Delhi',
        'INR',
        'Indian rupee',
        '₹',
        '.in',
        'भारत',
        'Asia',
        3,
        'Southern Asia',
        14,
        'Indian',
        '[{"zoneName":"Asia/Kolkata","gmtOffset":19800,"gmtOffsetName":"UTC+05:30","abbreviation":"IST","tzName":"Indian Standard Time"}]',
        '{"ko":"인도","pt-BR":"Índia","pt":"Índia","nl":"India","hr":"Indija","fa":"هند","de":"Indien","es":"India","fr":"Inde","ja":"インド","it":"India","zh-CN":"印度","tr":"Hindistan","ru":"Индия","uk":"Індія","pl":"Indie"}',
        20.00000000,
        77.00000000,
        '🇮🇳',
        'U+1F1EE U+1F1F3',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q668'
    );

INSERT INTO
    public.countries
VALUES
    (
        102,
        'Indonesia',
        'IDN',
        '360',
        'ID',
        '62',
        'Jakarta',
        'IDR',
        'Indonesian rupiah',
        'Rp',
        '.id',
        'Indonesia',
        'Asia',
        3,
        'South-Eastern Asia',
        13,
        'Indonesian',
        '[{"zoneName":"Asia/Jakarta","gmtOffset":25200,"gmtOffsetName":"UTC+07:00","abbreviation":"WIB","tzName":"Western Indonesian Time"},{"zoneName":"Asia/Jayapura","gmtOffset":32400,"gmtOffsetName":"UTC+09:00","abbreviation":"WIT","tzName":"Eastern Indonesian Time"},{"zoneName":"Asia/Makassar","gmtOffset":28800,"gmtOffsetName":"UTC+08:00","abbreviation":"WITA","tzName":"Central Indonesia Time"},{"zoneName":"Asia/Pontianak","gmtOffset":25200,"gmtOffsetName":"UTC+07:00","abbreviation":"WIB","tzName":"Western Indonesian Time"}]',
        '{"ko":"인도네시아","pt-BR":"Indonésia","pt":"Indonésia","nl":"Indonesië","hr":"Indonezija","fa":"اندونزی","de":"Indonesien","es":"Indonesia","fr":"Indonésie","ja":"インドネシア","it":"Indonesia","zh-CN":"印度尼西亚","tr":"Endonezya","ru":"Индонезия","uk":"Індонезія","pl":"Indonezja"}',
        -5.00000000,
        120.00000000,
        '🇮🇩',
        'U+1F1EE U+1F1E9',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q252'
    );

INSERT INTO
    public.countries
VALUES
    (
        103,
        'Iran',
        'IRN',
        '364',
        'IR',
        '98',
        'Tehran',
        'IRR',
        'Iranian rial',
        '﷼',
        '.ir',
        'ایران',
        'Asia',
        3,
        'Southern Asia',
        14,
        'Iranian, Persian',
        '[{"zoneName":"Asia/Tehran","gmtOffset":12600,"gmtOffsetName":"UTC+03:30","abbreviation":"IRDT","tzName":"Iran Daylight Time"}]',
        '{"ko":"이란","pt-BR":"Irã","pt":"Irão","nl":"Iran","hr":"Iran","fa":"ایران","de":"Iran","es":"Iran","fr":"Iran","ja":"イラン・イスラム共和国","zh-CN":"伊朗","tr":"İran","ru":"Иран","uk":"Іран","pl":"Iran"}',
        32.00000000,
        53.00000000,
        '🇮🇷',
        'U+1F1EE U+1F1F7',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q794'
    );

INSERT INTO
    public.countries
VALUES
    (
        104,
        'Iraq',
        'IRQ',
        '368',
        'IQ',
        '964',
        'Baghdad',
        'IQD',
        'Iraqi dinar',
        'د.ع',
        '.iq',
        'العراق',
        'Asia',
        3,
        'Western Asia',
        11,
        'Iraqi',
        '[{"zoneName":"Asia/Baghdad","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"AST","tzName":"Arabia Standard Time"}]',
        '{"ko":"이라크","pt-BR":"Iraque","pt":"Iraque","nl":"Irak","hr":"Irak","fa":"عراق","de":"Irak","es":"Irak","fr":"Irak","ja":"イラク","it":"Iraq","zh-CN":"伊拉克","tr":"Irak","ru":"Ирак","uk":"Ірак","pl":"Irak"}',
        33.00000000,
        44.00000000,
        '🇮🇶',
        'U+1F1EE U+1F1F6',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q796'
    );

INSERT INTO
    public.countries
VALUES
    (
        105,
        'Ireland',
        'IRL',
        '372',
        'IE',
        '353',
        'Dublin',
        'EUR',
        'Euro',
        '€',
        '.ie',
        'Éire',
        'Europe',
        4,
        'Northern Europe',
        18,
        'Irish',
        '[{"zoneName":"Europe/Dublin","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"아일랜드","pt-BR":"Irlanda","pt":"Irlanda","nl":"Ierland","hr":"Irska","fa":"ایرلند","de":"Irland","es":"Irlanda","fr":"Irlande","ja":"アイルランド","it":"Irlanda","zh-CN":"爱尔兰","tr":"İrlanda","ru":"Ирландия","uk":"Ірландія","pl":"Irlandia"}',
        53.00000000,
        -8.00000000,
        '🇮🇪',
        'U+1F1EE U+1F1EA',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q27'
    );

INSERT INTO
    public.countries
VALUES
    (
        106,
        'Israel',
        'ISR',
        '376',
        'IL',
        '972',
        'Jerusalem',
        'ILS',
        'Israeli new shekel',
        '₪',
        '.il',
        'יִשְׂרָאֵל',
        'Asia',
        3,
        'Western Asia',
        11,
        'Israeli',
        '[{"zoneName":"Asia/Jerusalem","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"IST","tzName":"Israel Standard Time"}]',
        '{"ko":"이스라엘","pt-BR":"Israel","pt":"Israel","nl":"Israël","hr":"Izrael","fa":"اسرائیل","de":"Israel","es":"Israel","fr":"Israël","ja":"イスラエル","it":"Israele","zh-CN":"以色列","tr":"İsrail","ru":"Израиль","uk":"Ізраїль","pl":"Izrael"}',
        31.50000000,
        34.75000000,
        '🇮🇱',
        'U+1F1EE U+1F1F1',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q801'
    );

INSERT INTO
    public.countries
VALUES
    (
        107,
        'Italy',
        'ITA',
        '380',
        'IT',
        '39',
        'Rome',
        'EUR',
        'Euro',
        '€',
        '.it',
        'Italia',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Italian',
        '[{"zoneName":"Europe/Rome","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"이탈리아","pt-BR":"Itália","pt":"Itália","nl":"Italië","hr":"Italija","fa":"ایتالیا","de":"Italien","es":"Italia","fr":"Italie","ja":"イタリア","it":"Italia","zh-CN":"意大利","tr":"İtalya","ru":"Италия","uk":"Італія","pl":"Włochy"}',
        42.83333333,
        12.83333333,
        '🇮🇹',
        'U+1F1EE U+1F1F9',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q38'
    );

INSERT INTO
    public.countries
VALUES
    (
        108,
        'Jamaica',
        'JAM',
        '388',
        'JM',
        '1',
        'Kingston',
        'JMD',
        'Jamaican dollar',
        'J$',
        '.jm',
        'Jamaica',
        'Americas',
        2,
        'Caribbean',
        7,
        'Jamaican',
        '[{"zoneName":"America/Jamaica","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"}]',
        '{"ko":"자메이카","pt-BR":"Jamaica","pt":"Jamaica","nl":"Jamaica","hr":"Jamajka","fa":"جامائیکا","de":"Jamaika","es":"Jamaica","fr":"Jamaïque","ja":"ジャマイカ","it":"Giamaica","zh-CN":"牙买加","tr":"Jamaika","ru":"Ямайка","uk":"Ямайка","pl":"Jamajka"}',
        18.25000000,
        -77.50000000,
        '🇯🇲',
        'U+1F1EF U+1F1F2',
        '2018-07-21 12:41:03',
        '2024-09-05 16:47:03',
        1,
        'Q766'
    );

INSERT INTO
    public.countries
VALUES
    (
        109,
        'Japan',
        'JPN',
        '392',
        'JP',
        '81',
        'Tokyo',
        'JPY',
        'Japanese yen',
        '¥',
        '.jp',
        '日本',
        'Asia',
        3,
        'Eastern Asia',
        12,
        'Japanese',
        '[{"zoneName":"Asia/Tokyo","gmtOffset":32400,"gmtOffsetName":"UTC+09:00","abbreviation":"JST","tzName":"Japan Standard Time"}]',
        '{"ko":"일본","pt-BR":"Japão","pt":"Japão","nl":"Japan","hr":"Japan","fa":"ژاپن","de":"Japan","es":"Japón","fr":"Japon","ja":"日本","it":"Giappone","zh-CN":"日本","tr":"Japonya","ru":"Япония","uk":"Японія","pl":"Japonia"}',
        36.00000000,
        138.00000000,
        '🇯🇵',
        'U+1F1EF U+1F1F5',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q17'
    );

INSERT INTO
    public.countries
VALUES
    (
        110,
        'Jersey',
        'JEY',
        '832',
        'JE',
        '44',
        'Saint Helier',
        'GBP',
        'British pound',
        '£',
        '.je',
        'Jersey',
        'Europe',
        4,
        'Northern Europe',
        18,
        'Channel Island',
        '[{"zoneName":"Europe/Jersey","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"저지 섬","pt-BR":"Jersey","pt":"Jersey","nl":"Jersey","hr":"Jersey","fa":"جرزی","de":"Jersey","es":"Jersey","fr":"Jersey","ja":"ジャージー","it":"Isola di Jersey","zh-CN":"泽西岛","tr":"Jersey","ru":"Джерси","uk":"Джерсі","pl":"Jersey"}',
        49.25000000,
        -2.16666666,
        '🇯🇪',
        'U+1F1EF U+1F1EA',
        '2018-07-21 12:41:03',
        '2024-09-05 16:47:03',
        1,
        'Q785'
    );

INSERT INTO
    public.countries
VALUES
    (
        111,
        'Jordan',
        'JOR',
        '400',
        'JO',
        '962',
        'Amman',
        'JOD',
        'Jordanian dinar',
        'ا.د',
        '.jo',
        'الأردن',
        'Asia',
        3,
        'Western Asia',
        11,
        'Jordanian',
        '[{"zoneName":"Asia/Amman","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"요르단","pt-BR":"Jordânia","pt":"Jordânia","nl":"Jordanië","hr":"Jordan","fa":"اردن","de":"Jordanien","es":"Jordania","fr":"Jordanie","ja":"ヨルダン","it":"Giordania","zh-CN":"约旦","tr":"Ürdün","ru":"Джордан","uk":"Йорданія","pl":"Jordan"}',
        31.00000000,
        36.00000000,
        '🇯🇴',
        'U+1F1EF U+1F1F4',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q810'
    );

INSERT INTO
    public.countries
VALUES
    (
        112,
        'Kazakhstan',
        'KAZ',
        '398',
        'KZ',
        '7',
        'Astana',
        'KZT',
        'Kazakhstani tenge',
        'лв',
        '.kz',
        'Қазақстан',
        'Asia',
        3,
        'Central Asia',
        10,
        'Kazakhstani, Kazakh',
        '[{"zoneName":"Asia/Almaty","gmtOffset":21600,"gmtOffsetName":"UTC+06:00","abbreviation":"ALMT","tzName":"Alma-Ata Time[1"},{"zoneName":"Asia/Aqtau","gmtOffset":18000,"gmtOffsetName":"UTC+05:00","abbreviation":"AQTT","tzName":"Aqtobe Time"},{"zoneName":"Asia/Aqtobe","gmtOffset":18000,"gmtOffsetName":"UTC+05:00","abbreviation":"AQTT","tzName":"Aqtobe Time"},{"zoneName":"Asia/Atyrau","gmtOffset":18000,"gmtOffsetName":"UTC+05:00","abbreviation":"MSD+1","tzName":"Moscow Daylight Time+1"},{"zoneName":"Asia/Oral","gmtOffset":18000,"gmtOffsetName":"UTC+05:00","abbreviation":"ORAT","tzName":"Oral Time"},{"zoneName":"Asia/Qostanay","gmtOffset":21600,"gmtOffsetName":"UTC+06:00","abbreviation":"QYZST","tzName":"Qyzylorda Summer Time"},{"zoneName":"Asia/Qyzylorda","gmtOffset":18000,"gmtOffsetName":"UTC+05:00","abbreviation":"QYZT","tzName":"Qyzylorda Summer Time"}]',
        '{"ko":"카자흐스탄","pt-BR":"Cazaquistão","pt":"Cazaquistão","nl":"Kazachstan","hr":"Kazahstan","fa":"قزاقستان","de":"Kasachstan","es":"Kazajistán","fr":"Kazakhstan","ja":"カザフスタン","it":"Kazakistan","zh-CN":"哈萨克斯坦","tr":"Kazakistan","ru":"Казахстан","uk":"Казахстан","pl":"Kazachstan"}',
        48.00000000,
        68.00000000,
        '🇰🇿',
        'U+1F1F0 U+1F1FF',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q232'
    );

INSERT INTO
    public.countries
VALUES
    (
        113,
        'Kenya',
        'KEN',
        '404',
        'KE',
        '254',
        'Nairobi',
        'KES',
        'Kenyan shilling',
        'KSh',
        '.ke',
        'Kenya',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Kenyan',
        '[{"zoneName":"Africa/Nairobi","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"EAT","tzName":"East Africa Time"}]',
        '{"ko":"케냐","pt-BR":"Quênia","pt":"Quénia","nl":"Kenia","hr":"Kenija","fa":"کنیا","de":"Kenia","es":"Kenia","fr":"Kenya","ja":"ケニア","it":"Kenya","zh-CN":"肯尼亚","tr":"Kenya","ru":"Кения","uk":"Кенія","pl":"Kenia"}',
        1.00000000,
        38.00000000,
        '🇰🇪',
        'U+1F1F0 U+1F1EA',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q114'
    );

INSERT INTO
    public.countries
VALUES
    (
        114,
        'Kiribati',
        'KIR',
        '296',
        'KI',
        '686',
        'Tarawa',
        'AUD',
        'Australian dollar',
        '$',
        '.ki',
        'Kiribati',
        'Oceania',
        5,
        'Micronesia',
        21,
        'I-Kiribati',
        '[{"zoneName":"Pacific/Enderbury","gmtOffset":46800,"gmtOffsetName":"UTC+13:00","abbreviation":"PHOT","tzName":"Phoenix Island Time"},{"zoneName":"Pacific/Kiritimati","gmtOffset":50400,"gmtOffsetName":"UTC+14:00","abbreviation":"LINT","tzName":"Line Islands Time"},{"zoneName":"Pacific/Tarawa","gmtOffset":43200,"gmtOffsetName":"UTC+12:00","abbreviation":"GILT","tzName":"Gilbert Island Time"}]',
        '{"ko":"키리바시","pt-BR":"Kiribati","pt":"Quiribáti","nl":"Kiribati","hr":"Kiribati","fa":"کیریباتی","de":"Kiribati","es":"Kiribati","fr":"Kiribati","ja":"キリバス","it":"Kiribati","zh-CN":"基里巴斯","tr":"Kiribati","ru":"Кирибати","uk":"Кірібаті","pl":"Kiribati"}',
        1.41666666,
        173.00000000,
        '🇰🇮',
        'U+1F1F0 U+1F1EE',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q710'
    );

INSERT INTO
    public.countries
VALUES
    (
        115,
        'North Korea',
        'PRK',
        '408',
        'KP',
        '850',
        'Pyongyang',
        'KPW',
        'North Korean Won',
        '₩',
        '.kp',
        '북한',
        'Asia',
        3,
        'Eastern Asia',
        12,
        'North Korean',
        '[{"zoneName":"Asia/Pyongyang","gmtOffset":32400,"gmtOffsetName":"UTC+09:00","abbreviation":"KST","tzName":"Korea Standard Time"}]',
        '{"ko":"조선민주주의인민공화국","pt-BR":"Coreia do Norte","pt":"Coreia do Norte","nl":"Noord-Korea","hr":"Sjeverna Koreja","fa":"کره جنوبی","de":"Nordkorea","es":"Corea del Norte","fr":"Corée du Nord","ja":"朝鮮民主主義人民共和国","it":"Corea del Nord","zh-CN":"朝鲜","tr":"Kuzey Kore","ru":"Северная Корея","uk":"Північна Корея","pl":"Korea Północna"}',
        40.00000000,
        127.00000000,
        '🇰🇵',
        'U+1F1F0 U+1F1F5',
        '2018-07-21 12:41:03',
        '2023-08-11 21:15:55',
        1,
        'Q423'
    );

INSERT INTO
    public.countries
VALUES
    (
        116,
        'South Korea',
        'KOR',
        '410',
        'KR',
        '82',
        'Seoul',
        'KRW',
        'Won',
        '₩',
        '.kr',
        '대한민국',
        'Asia',
        3,
        'Eastern Asia',
        12,
        'South Korean',
        '[{"zoneName":"Asia/Seoul","gmtOffset":32400,"gmtOffsetName":"UTC+09:00","abbreviation":"KST","tzName":"Korea Standard Time"}]',
        '{"ko":"대한민국","pt-BR":"Coreia do Sul","pt":"Coreia do Sul","nl":"Zuid-Korea","hr":"Južna Koreja","fa":"کره شمالی","de":"Südkorea","es":"Corea del Sur","fr":"Corée du Sud","ja":"大韓民国","it":"Corea del Sud","zh-CN":"韩国","tr":"Güney Kore","ru":"Южная Корея","uk":"Південна Корея","pl":"Korea Południowa"}',
        37.00000000,
        127.50000000,
        '🇰🇷',
        'U+1F1F0 U+1F1F7',
        '2018-07-21 12:41:03',
        '2023-08-11 21:15:55',
        1,
        'Q884'
    );

INSERT INTO
    public.countries
VALUES
    (
        117,
        'Kuwait',
        'KWT',
        '414',
        'KW',
        '965',
        'Kuwait City',
        'KWD',
        'Kuwaiti dinar',
        'ك.د',
        '.kw',
        'الكويت',
        'Asia',
        3,
        'Western Asia',
        11,
        'Kuwaiti',
        '[{"zoneName":"Asia/Kuwait","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"AST","tzName":"Arabia Standard Time"}]',
        '{"ko":"쿠웨이트","pt-BR":"Kuwait","pt":"Kuwait","nl":"Koeweit","hr":"Kuvajt","fa":"کویت","de":"Kuwait","es":"Kuwait","fr":"Koweït","ja":"クウェート","it":"Kuwait","zh-CN":"科威特","tr":"Kuveyt","ru":"Кувейт","uk":"Кувейт","pl":"Kuwejt"}',
        29.50000000,
        45.75000000,
        '🇰🇼',
        'U+1F1F0 U+1F1FC',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q817'
    );

INSERT INTO
    public.countries
VALUES
    (
        118,
        'Kyrgyzstan',
        'KGZ',
        '417',
        'KG',
        '996',
        'Bishkek',
        'KGS',
        'Kyrgyzstani som',
        'лв',
        '.kg',
        'Кыргызстан',
        'Asia',
        3,
        'Central Asia',
        10,
        'Kyrgyzstani, Kyrgyz, Kirgiz, Kirghiz',
        '[{"zoneName":"Asia/Bishkek","gmtOffset":21600,"gmtOffsetName":"UTC+06:00","abbreviation":"KGT","tzName":"Kyrgyzstan Time"}]',
        '{"ko":"키르기스스탄","pt-BR":"Quirguistão","pt":"Quirguizistão","nl":"Kirgizië","hr":"Kirgistan","fa":"قرقیزستان","de":"Kirgisistan","es":"Kirguizistán","fr":"Kirghizistan","ja":"キルギス","it":"Kirghizistan","zh-CN":"吉尔吉斯斯坦","tr":"Kirgizistan","ru":"Кыргызстан","uk":"Киргизстан","pl":"Kirgistan"}',
        41.00000000,
        75.00000000,
        '🇰🇬',
        'U+1F1F0 U+1F1EC',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q813'
    );

INSERT INTO
    public.countries
VALUES
    (
        119,
        'Laos',
        'LAO',
        '418',
        'LA',
        '856',
        'Vientiane',
        'LAK',
        'Lao kip',
        '₭',
        '.la',
        'ສປປລາວ',
        'Asia',
        3,
        'South-Eastern Asia',
        13,
        'Lao, Laotian',
        '[{"zoneName":"Asia/Vientiane","gmtOffset":25200,"gmtOffsetName":"UTC+07:00","abbreviation":"ICT","tzName":"Indochina Time"}]',
        '{"ko":"라오스","pt-BR":"Laos","pt":"Laos","nl":"Laos","hr":"Laos","fa":"لائوس","de":"Laos","es":"Laos","fr":"Laos","ja":"ラオス人民民主共和国","it":"Laos","zh-CN":"寮人民民主共和国","tr":"Laos","ru":"Лаос","uk":"Лаос","pl":"Laos"}',
        18.00000000,
        105.00000000,
        '🇱🇦',
        'U+1F1F1 U+1F1E6',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q819'
    );

INSERT INTO
    public.countries
VALUES
    (
        120,
        'Latvia',
        'LVA',
        '428',
        'LV',
        '371',
        'Riga',
        'EUR',
        'Euro',
        '€',
        '.lv',
        'Latvija',
        'Europe',
        4,
        'Northern Europe',
        18,
        'Latvian',
        '[{"zoneName":"Europe/Riga","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"라트비아","pt-BR":"Letônia","pt":"Letónia","nl":"Letland","hr":"Latvija","fa":"لتونی","de":"Lettland","es":"Letonia","fr":"Lettonie","ja":"ラトビア","it":"Lettonia","zh-CN":"拉脱维亚","tr":"Letonya","ru":"Латвия","uk":"Латвія","pl":"Łotwa"}',
        57.00000000,
        25.00000000,
        '🇱🇻',
        'U+1F1F1 U+1F1FB',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q211'
    );

INSERT INTO
    public.countries
VALUES
    (
        121,
        'Lebanon',
        'LBN',
        '422',
        'LB',
        '961',
        'Beirut',
        'LBP',
        'Lebanese pound',
        '£',
        '.lb',
        'لبنان',
        'Asia',
        3,
        'Western Asia',
        11,
        'Lebanese',
        '[{"zoneName":"Asia/Beirut","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"레바논","pt-BR":"Líbano","pt":"Líbano","nl":"Libanon","hr":"Libanon","fa":"لبنان","de":"Libanon","es":"Líbano","fr":"Liban","ja":"レバノン","it":"Libano","zh-CN":"黎巴嫩","tr":"Lübnan","ru":"Ливан","uk":"Ліван","pl":"Liban"}',
        33.83333333,
        35.83333333,
        '🇱🇧',
        'U+1F1F1 U+1F1E7',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q822'
    );

INSERT INTO
    public.countries
VALUES
    (
        122,
        'Lesotho',
        'LSO',
        '426',
        'LS',
        '266',
        'Maseru',
        'LSL',
        'Lesotho loti',
        'L',
        '.ls',
        'Lesotho',
        'Africa',
        1,
        'Southern Africa',
        5,
        'Basotho',
        '[{"zoneName":"Africa/Maseru","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"SAST","tzName":"South African Standard Time"}]',
        '{"ko":"레소토","pt-BR":"Lesoto","pt":"Lesoto","nl":"Lesotho","hr":"Lesoto","fa":"لسوتو","de":"Lesotho","es":"Lesotho","fr":"Lesotho","ja":"レソト","it":"Lesotho","zh-CN":"莱索托","tr":"Lesotho","ru":"Лесото","uk":"Лесото","pl":"Lesotho"}',
        -29.50000000,
        28.50000000,
        '🇱🇸',
        'U+1F1F1 U+1F1F8',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q1013'
    );

INSERT INTO
    public.countries
VALUES
    (
        123,
        'Liberia',
        'LBR',
        '430',
        'LR',
        '231',
        'Monrovia',
        'LRD',
        'Liberian dollar',
        '$',
        '.lr',
        'Liberia',
        'Africa',
        1,
        'Western Africa',
        3,
        'Liberian',
        '[{"zoneName":"Africa/Monrovia","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"라이베리아","pt-BR":"Libéria","pt":"Libéria","nl":"Liberia","hr":"Liberija","fa":"لیبریا","de":"Liberia","es":"Liberia","fr":"Liberia","ja":"リベリア","it":"Liberia","zh-CN":"利比里亚","tr":"Liberya","ru":"Либерия","uk":"Ліберія","pl":"Liberia"}',
        6.50000000,
        -9.50000000,
        '🇱🇷',
        'U+1F1F1 U+1F1F7',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q1014'
    );

INSERT INTO
    public.countries
VALUES
    (
        124,
        'Libya',
        'LBY',
        '434',
        'LY',
        '218',
        'Tripolis',
        'LYD',
        'Libyan dinar',
        'د.ل',
        '.ly',
        '‏ليبيا',
        'Africa',
        1,
        'Northern Africa',
        1,
        'Libyan',
        '[{"zoneName":"Africa/Tripoli","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"리비아","pt-BR":"Líbia","pt":"Líbia","nl":"Libië","hr":"Libija","fa":"لیبی","de":"Libyen","es":"Libia","fr":"Libye","ja":"リビア","it":"Libia","zh-CN":"利比亚","tr":"Libya","ru":"Ливия","uk":"Лівія","pl":"Libia"}',
        25.00000000,
        17.00000000,
        '🇱🇾',
        'U+1F1F1 U+1F1FE',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q1016'
    );

INSERT INTO
    public.countries
VALUES
    (
        125,
        'Liechtenstein',
        'LIE',
        '438',
        'LI',
        '423',
        'Vaduz',
        'CHF',
        'Swiss franc',
        'CHf',
        '.li',
        'Liechtenstein',
        'Europe',
        4,
        'Western Europe',
        17,
        'Liechtenstein',
        '[{"zoneName":"Europe/Vaduz","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"리히텐슈타인","pt-BR":"Liechtenstein","pt":"Listenstaine","nl":"Liechtenstein","hr":"Lihtenštajn","fa":"لیختن‌اشتاین","de":"Liechtenstein","es":"Liechtenstein","fr":"Liechtenstein","ja":"リヒテンシュタイン","it":"Liechtenstein","zh-CN":"列支敦士登","tr":"Lihtenştayn","ru":"Лихтенштейн","uk":"Ліхтенштейн","pl":"Liechtenstein"}',
        47.26666666,
        9.53333333,
        '🇱🇮',
        'U+1F1F1 U+1F1EE',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q347'
    );

INSERT INTO
    public.countries
VALUES
    (
        126,
        'Lithuania',
        'LTU',
        '440',
        'LT',
        '370',
        'Vilnius',
        'EUR',
        'Euro',
        '€',
        '.lt',
        'Lietuva',
        'Europe',
        4,
        'Northern Europe',
        18,
        'Lithuanian',
        '[{"zoneName":"Europe/Vilnius","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"리투아니아","pt-BR":"Lituânia","pt":"Lituânia","nl":"Litouwen","hr":"Litva","fa":"لیتوانی","de":"Litauen","es":"Lituania","fr":"Lituanie","ja":"リトアニア","it":"Lituania","zh-CN":"立陶宛","tr":"Litvanya","ru":"Литва","uk":"Литва","pl":"Litwa"}',
        56.00000000,
        24.00000000,
        '🇱🇹',
        'U+1F1F1 U+1F1F9',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q37'
    );

INSERT INTO
    public.countries
VALUES
    (
        127,
        'Luxembourg',
        'LUX',
        '442',
        'LU',
        '352',
        'Luxembourg',
        'EUR',
        'Euro',
        '€',
        '.lu',
        'Luxembourg',
        'Europe',
        4,
        'Western Europe',
        17,
        'Luxembourg, Luxembourgish',
        '[{"zoneName":"Europe/Luxembourg","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"룩셈부르크","pt-BR":"Luxemburgo","pt":"Luxemburgo","nl":"Luxemburg","hr":"Luksemburg","fa":"لوکزامبورگ","de":"Luxemburg","es":"Luxemburgo","fr":"Luxembourg","ja":"ルクセンブルク","it":"Lussemburgo","zh-CN":"卢森堡","tr":"Lüksemburg","ru":"Люксембург","uk":"Люксембург","pl":"Luksemburg"}',
        49.75000000,
        6.16666666,
        '🇱🇺',
        'U+1F1F1 U+1F1FA',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q32'
    );

INSERT INTO
    public.countries
VALUES
    (
        128,
        'Macau S.A.R.',
        'MAC',
        '446',
        'MO',
        '853',
        'Macao',
        'MOP',
        'Macanese pataca',
        '$',
        '.mo',
        '澳門',
        'Asia',
        3,
        'Eastern Asia',
        12,
        'Macanese, Chinese',
        '[{"zoneName":"Asia/Macau","gmtOffset":28800,"gmtOffsetName":"UTC+08:00","abbreviation":"CST","tzName":"China Standard Time"}]',
        '{"ko":"마카오","pt-BR":"Macau","pt":"Macau","nl":"Macao","hr":"Makao","fa":"مکائو","de":"Macao","es":"Macao","fr":"Macao","ja":"マカオ","it":"Macao","zh-CN":"中国澳门","tr":"Makao","ru":"Макао С.А.Р.","uk":"САР Макао.","pl":"Macau S.A.R."}',
        22.16666666,
        113.55000000,
        '🇲🇴',
        'U+1F1F2 U+1F1F4',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q14773'
    );

INSERT INTO
    public.countries
VALUES
    (
        129,
        'North Macedonia',
        'MKD',
        '807',
        'MK',
        '389',
        'Skopje',
        'MKD',
        'Denar',
        'ден',
        '.mk',
        'Северна Македонија',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Macedonian',
        '[{"zoneName":"Europe/Skopje","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"북마케도니아","pt-BR":"Macedônia do Norte","pt":"Macedónia do Norte","nl":"Noord-Macedonië","hr":"Sjeverna Makedonija","fa":"ﻢﻗﺩﻮﻨﯿﻫ ﺶﻣﺎﻠﯾ","de":"Nordmazedonien","es":"Macedonia del Norte","fr":"Macédoine du Nord","ja":"北マケドニア","it":"Macedonia del Nord","zh-CN":"北馬其頓","tr":"Kuzey Makedonya","ru":"Северная Македония","uk":"Північна Македонія","pl":"Macedonia Północna"}',
        41.83333333,
        22.00000000,
        '🇲🇰',
        'U+1F1F2 U+1F1F0',
        '2018-07-21 12:41:03',
        '2023-08-11 21:15:55',
        1,
        'Q221'
    );

INSERT INTO
    public.countries
VALUES
    (
        130,
        'Madagascar',
        'MDG',
        '450',
        'MG',
        '261',
        'Antananarivo',
        'MGA',
        'Malagasy ariary',
        'Ar',
        '.mg',
        'Madagasikara',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Malagasy',
        '[{"zoneName":"Indian/Antananarivo","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"EAT","tzName":"East Africa Time"}]',
        '{"ko":"마다가스카르","pt-BR":"Madagascar","pt":"Madagáscar","nl":"Madagaskar","hr":"Madagaskar","fa":"ماداگاسکار","de":"Madagaskar","es":"Madagascar","fr":"Madagascar","ja":"マダガスカル","it":"Madagascar","zh-CN":"马达加斯加","tr":"Madagaskar","ru":"Мадагаскар","uk":"Мадагаскар","pl":"Madagaskar"}',
        -20.00000000,
        47.00000000,
        '🇲🇬',
        'U+1F1F2 U+1F1EC',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q1019'
    );

INSERT INTO
    public.countries
VALUES
    (
        131,
        'Malawi',
        'MWI',
        '454',
        'MW',
        '265',
        'Lilongwe',
        'MWK',
        'Malawian kwacha',
        'MK',
        '.mw',
        'Malawi',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Malawian',
        '[{"zoneName":"Africa/Blantyre","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"CAT","tzName":"Central Africa Time"}]',
        '{"ko":"말라위","pt-BR":"Malawi","pt":"Malávi","nl":"Malawi","hr":"Malavi","fa":"مالاوی","de":"Malawi","es":"Malawi","fr":"Malawi","ja":"マラウイ","it":"Malawi","zh-CN":"马拉维","tr":"Malavi","ru":"Малави","uk":"Малаві","pl":"Malawi"}',
        -13.50000000,
        34.00000000,
        '🇲🇼',
        'U+1F1F2 U+1F1FC',
        '2018-07-21 12:41:03',
        '2023-08-09 02:34:58',
        1,
        'Q1020'
    );

INSERT INTO
    public.countries
VALUES
    (
        132,
        'Malaysia',
        'MYS',
        '458',
        'MY',
        '60',
        'Kuala Lumpur',
        'MYR',
        'Malaysian ringgit',
        'RM',
        '.my',
        'Malaysia',
        'Asia',
        3,
        'South-Eastern Asia',
        13,
        'Malaysian',
        '[{"zoneName":"Asia/Kuala_Lumpur","gmtOffset":28800,"gmtOffsetName":"UTC+08:00","abbreviation":"MYT","tzName":"Malaysia Time"},{"zoneName":"Asia/Kuching","gmtOffset":28800,"gmtOffsetName":"UTC+08:00","abbreviation":"MYT","tzName":"Malaysia Time"}]',
        '{"ko":"말레이시아","pt-BR":"Malásia","pt":"Malásia","nl":"Maleisië","hr":"Malezija","fa":"مالزی","de":"Malaysia","es":"Malasia","fr":"Malaisie","ja":"マレーシア","it":"Malesia","zh-CN":"马来西亚","tr":"Malezya","ru":"Малайзия","uk":"Малайзія","pl":"Malezja"}',
        2.50000000,
        112.50000000,
        '🇲🇾',
        'U+1F1F2 U+1F1FE',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q833'
    );

INSERT INTO
    public.countries
VALUES
    (
        133,
        'Maldives',
        'MDV',
        '462',
        'MV',
        '960',
        'Male',
        'MVR',
        'Maldivian rufiyaa',
        'Rf',
        '.mv',
        'Maldives',
        'Asia',
        3,
        'Southern Asia',
        14,
        'Maldivian',
        '[{"zoneName":"Indian/Maldives","gmtOffset":18000,"gmtOffsetName":"UTC+05:00","abbreviation":"MVT","tzName":"Maldives Time"}]',
        '{"ko":"몰디브","pt-BR":"Maldivas","pt":"Maldivas","nl":"Maldiven","hr":"Maldivi","fa":"مالدیو","de":"Malediven","es":"Maldivas","fr":"Maldives","ja":"モルディブ","it":"Maldive","zh-CN":"马尔代夫","tr":"Maldivler","ru":"Мальдивы","uk":"Мальдіви","pl":"Malediwy"}',
        3.25000000,
        73.00000000,
        '🇲🇻',
        'U+1F1F2 U+1F1FB',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q826'
    );

INSERT INTO
    public.countries
VALUES
    (
        134,
        'Mali',
        'MLI',
        '466',
        'ML',
        '223',
        'Bamako',
        'XOF',
        'West African CFA franc',
        'CFA',
        '.ml',
        'Mali',
        'Africa',
        1,
        'Western Africa',
        3,
        'Malian, Malinese',
        '[{"zoneName":"Africa/Bamako","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"말리","pt-BR":"Mali","pt":"Mali","nl":"Mali","hr":"Mali","fa":"مالی","de":"Mali","es":"Mali","fr":"Mali","ja":"マリ","it":"Mali","zh-CN":"马里","tr":"Mali","ru":"Мали","uk":"Малі","pl":"Mali"}',
        17.00000000,
        -4.00000000,
        '🇲🇱',
        'U+1F1F2 U+1F1F1',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q912'
    );

INSERT INTO
    public.countries
VALUES
    (
        135,
        'Malta',
        'MLT',
        '470',
        'MT',
        '356',
        'Valletta',
        'EUR',
        'Euro',
        '€',
        '.mt',
        'Malta',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Maltese',
        '[{"zoneName":"Europe/Malta","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"몰타","pt-BR":"Malta","pt":"Malta","nl":"Malta","hr":"Malta","fa":"مالت","de":"Malta","es":"Malta","fr":"Malte","ja":"マルタ","it":"Malta","zh-CN":"马耳他","tr":"Malta","ru":"Мальта","uk":"Мальта","pl":"Malta"}',
        35.83333333,
        14.58333333,
        '🇲🇹',
        'U+1F1F2 U+1F1F9',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q233'
    );

INSERT INTO
    public.countries
VALUES
    (
        136,
        'Man (Isle of)',
        'IMN',
        '833',
        'IM',
        '44',
        'Douglas, Isle of Man',
        'GBP',
        'British pound',
        '£',
        '.im',
        'Isle of Man',
        'Europe',
        4,
        'Northern Europe',
        18,
        'Manx',
        '[{"zoneName":"Europe/Isle_of_Man","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"맨 섬","pt-BR":"Ilha de Man","pt":"Ilha de Man","nl":"Isle of Man","hr":"Otok Man","fa":"جزیره من","de":"Insel Man","es":"Isla de Man","fr":"Île de Man","ja":"マン島","it":"Isola di Man","zh-CN":"马恩岛","tr":"Man Adasi","ru":"Мэн (остров)","uk":"Мен (острів Мен)","pl":"Man (Wyspa)"}',
        54.25000000,
        -4.50000000,
        '🇮🇲',
        'U+1F1EE U+1F1F2',
        '2018-07-21 12:41:03',
        '2024-09-05 16:47:03',
        1,
        NULL
    );

INSERT INTO
    public.countries
VALUES
    (
        137,
        'Marshall Islands',
        'MHL',
        '584',
        'MH',
        '692',
        'Majuro',
        'USD',
        'United States dollar',
        '$',
        '.mh',
        'M̧ajeļ',
        'Oceania',
        5,
        'Micronesia',
        21,
        'Marshallese',
        '[{"zoneName":"Pacific/Kwajalein","gmtOffset":43200,"gmtOffsetName":"UTC+12:00","abbreviation":"MHT","tzName":"Marshall Islands Time"},{"zoneName":"Pacific/Majuro","gmtOffset":43200,"gmtOffsetName":"UTC+12:00","abbreviation":"MHT","tzName":"Marshall Islands Time"}]',
        '{"ko":"마셜 제도","pt-BR":"Ilhas Marshall","pt":"Ilhas Marshall","nl":"Marshalleilanden","hr":"Maršalovi Otoci","fa":"جزایر مارشال","de":"Marshallinseln","es":"Islas Marshall","fr":"Îles Marshall","ja":"マーシャル諸島","it":"Isole Marshall","zh-CN":"马绍尔群岛","tr":"Marşal Adalari","ru":"Маршалловы острова","uk":"Маршаллові острови","pl":"Wyspy Marshalla"}',
        9.00000000,
        168.00000000,
        '🇲🇭',
        'U+1F1F2 U+1F1ED',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q709'
    );

INSERT INTO
    public.countries
VALUES
    (
        138,
        'Martinique',
        'MTQ',
        '474',
        'MQ',
        '596',
        'Fort-de-France',
        'EUR',
        'Euro',
        '€',
        '.mq',
        'Martinique',
        'Americas',
        2,
        'Caribbean',
        7,
        'Martiniquais, Martinican',
        '[{"zoneName":"America/Martinique","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"마르티니크","pt-BR":"Martinica","pt":"Martinica","nl":"Martinique","hr":"Martinique","fa":"مونتسرات","de":"Martinique","es":"Martinica","fr":"Martinique","ja":"マルティニーク","it":"Martinica","zh-CN":"马提尼克岛","tr":"Martinik","ru":"Мартиника","uk":"Мартініка","pl":"Martynika"}',
        14.66666700,
        -61.00000000,
        '🇲🇶',
        'U+1F1F2 U+1F1F6',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q17054'
    );

INSERT INTO
    public.countries
VALUES
    (
        139,
        'Mauritania',
        'MRT',
        '478',
        'MR',
        '222',
        'Nouakchott',
        'MRU',
        'Mauritanian ouguiya',
        'UM',
        '.mr',
        'موريتانيا',
        'Africa',
        1,
        'Western Africa',
        3,
        'Mauritanian',
        '[{"zoneName":"Africa/Nouakchott","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"모리타니","pt-BR":"Mauritânia","pt":"Mauritânia","nl":"Mauritanië","hr":"Mauritanija","fa":"موریتانی","de":"Mauretanien","es":"Mauritania","fr":"Mauritanie","ja":"モーリタニア","it":"Mauritania","zh-CN":"毛里塔尼亚","tr":"Moritanya","ru":"Мавритания","uk":"Мавританія","pl":"Mauretania"}',
        20.00000000,
        -12.00000000,
        '🇲🇷',
        'U+1F1F2 U+1F1F7',
        '2018-07-21 12:41:03',
        '2025-03-22 20:09:58',
        1,
        'Q1025'
    );

INSERT INTO
    public.countries
VALUES
    (
        140,
        'Mauritius',
        'MUS',
        '480',
        'MU',
        '230',
        'Port Louis',
        'MUR',
        'Mauritian rupee',
        '₨',
        '.mu',
        'Maurice',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Mauritian',
        '[{"zoneName":"Indian/Mauritius","gmtOffset":14400,"gmtOffsetName":"UTC+04:00","abbreviation":"MUT","tzName":"Mauritius Time"}]',
        '{"ko":"모리셔스","pt-BR":"Maurício","pt":"Maurícia","nl":"Mauritius","hr":"Mauricijus","fa":"موریس","de":"Mauritius","es":"Mauricio","fr":"Île Maurice","ja":"モーリシャス","it":"Mauritius","zh-CN":"毛里求斯","tr":"Morityus","ru":"Маврикий","uk":"Маврикій","pl":"Mauritius"}',
        -20.28333333,
        57.55000000,
        '🇲🇺',
        'U+1F1F2 U+1F1FA',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q1027'
    );

INSERT INTO
    public.countries
VALUES
    (
        141,
        'Mayotte',
        'MYT',
        '175',
        'YT',
        '262',
        'Mamoudzou',
        'EUR',
        'Euro',
        '€',
        '.yt',
        'Mayotte',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Mahoran',
        '[{"zoneName":"Indian/Mayotte","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"EAT","tzName":"East Africa Time"}]',
        '{"ko":"마요트","pt-BR":"Mayotte","pt":"Mayotte","nl":"Mayotte","hr":"Mayotte","fa":"مایوت","de":"Mayotte","es":"Mayotte","fr":"Mayotte","ja":"マヨット","it":"Mayotte","zh-CN":"马约特","tr":"Mayotte","ru":"Майотта","uk":"Майотта","pl":"Majotta"}',
        -12.83333333,
        45.16666666,
        '🇾🇹',
        'U+1F1FE U+1F1F9',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q17063'
    );

INSERT INTO
    public.countries
VALUES
    (
        142,
        'Mexico',
        'MEX',
        '484',
        'MX',
        '52',
        'Ciudad de México',
        'MXN',
        'Mexican peso',
        '$',
        '.mx',
        'México',
        'Americas',
        2,
        'Central America',
        9,
        'Mexican',
        '[{"zoneName":"America/Bahia_Banderas","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/Cancun","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"},{"zoneName":"America/Chihuahua","gmtOffset":-25200,"gmtOffsetName":"UTC-07:00","abbreviation":"MST","tzName":"Mountain Standard Time (North America"},{"zoneName":"America/Hermosillo","gmtOffset":-25200,"gmtOffsetName":"UTC-07:00","abbreviation":"MST","tzName":"Mountain Standard Time (North America"},{"zoneName":"America/Matamoros","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/Mazatlan","gmtOffset":-25200,"gmtOffsetName":"UTC-07:00","abbreviation":"MST","tzName":"Mountain Standard Time (North America"},{"zoneName":"America/Merida","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/Mexico_City","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/Monterrey","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/Ojinaga","gmtOffset":-25200,"gmtOffsetName":"UTC-07:00","abbreviation":"MST","tzName":"Mountain Standard Time (North America"},{"zoneName":"America/Tijuana","gmtOffset":-28800,"gmtOffsetName":"UTC-08:00","abbreviation":"PST","tzName":"Pacific Standard Time (North America"}]',
        '{"ko":"멕시코","pt-BR":"México","pt":"México","nl":"Mexico","hr":"Meksiko","fa":"مکزیک","de":"Mexiko","es":"México","fr":"Mexique","ja":"メキシコ","it":"Messico","zh-CN":"墨西哥","tr":"Meksika","ru":"Мексика","uk":"Мексика","pl":"Meksyk"}',
        23.00000000,
        -102.00000000,
        '🇲🇽',
        'U+1F1F2 U+1F1FD',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q96'
    );

INSERT INTO
    public.countries
VALUES
    (
        143,
        'Micronesia',
        'FSM',
        '583',
        'FM',
        '691',
        'Palikir',
        'USD',
        'United States dollar',
        '$',
        '.fm',
        'Micronesia',
        'Oceania',
        5,
        'Micronesia',
        21,
        'Micronesian',
        '[{"zoneName":"Pacific/Chuuk","gmtOffset":36000,"gmtOffsetName":"UTC+10:00","abbreviation":"CHUT","tzName":"Chuuk Time"},{"zoneName":"Pacific/Kosrae","gmtOffset":39600,"gmtOffsetName":"UTC+11:00","abbreviation":"KOST","tzName":"Kosrae Time"},{"zoneName":"Pacific/Pohnpei","gmtOffset":39600,"gmtOffsetName":"UTC+11:00","abbreviation":"PONT","tzName":"Pohnpei Standard Time"}]',
        '{"ko":"미크로네시아 연방","pt-BR":"Micronésia","pt":"Micronésia","nl":"Micronesië","hr":"Mikronezija","fa":"ایالات فدرال میکرونزی","de":"Mikronesien","es":"Micronesia","fr":"Micronésie","ja":"ミクロネシア連邦","it":"Micronesia","zh-CN":"密克罗尼西亚","tr":"Mikronezya","ru":"Микронезия","uk":"Мікронезія","pl":"Mikronezja"}',
        6.91666666,
        158.25000000,
        '🇫🇲',
        'U+1F1EB U+1F1F2',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q702'
    );

INSERT INTO
    public.countries
VALUES
    (
        144,
        'Moldova',
        'MDA',
        '498',
        'MD',
        '373',
        'Chisinau',
        'MDL',
        'Moldovan leu',
        'L',
        '.md',
        'Moldova',
        'Europe',
        4,
        'Eastern Europe',
        15,
        'Moldovan',
        '[{"zoneName":"Europe/Chisinau","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"몰도바","pt-BR":"Moldávia","pt":"Moldávia","nl":"Moldavië","hr":"Moldova","fa":"مولداوی","de":"Moldawie","es":"Moldavia","fr":"Moldavie","ja":"モルドバ共和国","it":"Moldavia","zh-CN":"摩尔多瓦","tr":"Moldova","ru":"Молдова","uk":"Молдова","pl":"Mołdawia"}',
        47.00000000,
        29.00000000,
        '🇲🇩',
        'U+1F1F2 U+1F1E9',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q217'
    );

INSERT INTO
    public.countries
VALUES
    (
        146,
        'Mongolia',
        'MNG',
        '496',
        'MN',
        '976',
        'Ulan Bator',
        'MNT',
        'Mongolian tögrög',
        '₮',
        '.mn',
        'Монгол улс',
        'Asia',
        3,
        'Eastern Asia',
        12,
        'Mongolian',
        '[{"zoneName":"Asia/Choibalsan","gmtOffset":28800,"gmtOffsetName":"UTC+08:00","abbreviation":"CHOT","tzName":"Choibalsan Standard Time"},{"zoneName":"Asia/Hovd","gmtOffset":25200,"gmtOffsetName":"UTC+07:00","abbreviation":"HOVT","tzName":"Hovd Time"},{"zoneName":"Asia/Ulaanbaatar","gmtOffset":28800,"gmtOffsetName":"UTC+08:00","abbreviation":"ULAT","tzName":"Ulaanbaatar Standard Time"}]',
        '{"ko":"몽골","pt-BR":"Mongólia","pt":"Mongólia","nl":"Mongolië","hr":"Mongolija","fa":"مغولستان","de":"Mongolei","es":"Mongolia","fr":"Mongolie","ja":"モンゴル","it":"Mongolia","zh-CN":"蒙古","tr":"Moğolistan","ru":"Монголия","uk":"Монголія","pl":"Mongolia"}',
        46.00000000,
        105.00000000,
        '🇲🇳',
        'U+1F1F2 U+1F1F3',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q711'
    );

INSERT INTO
    public.countries
VALUES
    (
        147,
        'Montenegro',
        'MNE',
        '499',
        'ME',
        '382',
        'Podgorica',
        'EUR',
        'Euro',
        '€',
        '.me',
        'Црна Гора',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Montenegrin',
        '[{"zoneName":"Europe/Podgorica","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"몬테네그로","pt-BR":"Montenegro","pt":"Montenegro","nl":"Montenegro","hr":"Crna Gora","fa":"مونته‌نگرو","de":"Montenegro","es":"Montenegro","fr":"Monténégro","ja":"モンテネグロ","it":"Montenegro","zh-CN":"黑山","tr":"Karadağ","ru":"Черногория","uk":"Чорногорія","pl":"Czarnogóra"}',
        42.50000000,
        19.30000000,
        '🇲🇪',
        'U+1F1F2 U+1F1EA',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q236'
    );

INSERT INTO
    public.countries
VALUES
    (
        148,
        'Montserrat',
        'MSR',
        '500',
        'MS',
        '1',
        'Plymouth',
        'XCD',
        'Eastern Caribbean dollar',
        '$',
        '.ms',
        'Montserrat',
        'Americas',
        2,
        'Caribbean',
        7,
        'Montserratian',
        '[{"zoneName":"America/Montserrat","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"몬트세랫","pt-BR":"Montserrat","pt":"Monserrate","nl":"Montserrat","hr":"Montserrat","fa":"مایوت","de":"Montserrat","es":"Montserrat","fr":"Montserrat","ja":"モントセラト","it":"Montserrat","zh-CN":"蒙特塞拉特","tr":"Montserrat","ru":"Монтсеррат","uk":"Монтсеррат","pl":"Montserrat"}',
        16.75000000,
        -62.20000000,
        '🇲🇸',
        'U+1F1F2 U+1F1F8',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q13353'
    );

INSERT INTO
    public.countries
VALUES
    (
        149,
        'Morocco',
        'MAR',
        '504',
        'MA',
        '212',
        'Rabat',
        'MAD',
        'Moroccan dirham',
        'DH',
        '.ma',
        'المغرب',
        'Africa',
        1,
        'Northern Africa',
        1,
        'Moroccan',
        '[{"zoneName":"Africa/Casablanca","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"WEST","tzName":"Western European Summer Time"}]',
        '{"ko":"모로코","pt-BR":"Marrocos","pt":"Marrocos","nl":"Marokko","hr":"Maroko","fa":"مراکش","de":"Marokko","es":"Marruecos","fr":"Maroc","ja":"モロッコ","it":"Marocco","zh-CN":"摩洛哥","tr":"Fas","ru":"Марокко","uk":"Марокко","pl":"Maroko"}',
        32.00000000,
        -5.00000000,
        '🇲🇦',
        'U+1F1F2 U+1F1E6',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q1028'
    );

INSERT INTO
    public.countries
VALUES
    (
        150,
        'Mozambique',
        'MOZ',
        '508',
        'MZ',
        '258',
        'Maputo',
        'MZN',
        'Mozambican metical',
        'MT',
        '.mz',
        'Moçambique',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Mozambican',
        '[{"zoneName":"Africa/Maputo","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"CAT","tzName":"Central Africa Time"}]',
        '{"ko":"모잠비크","pt-BR":"Moçambique","pt":"Moçambique","nl":"Mozambique","hr":"Mozambik","fa":"موزامبیک","de":"Mosambik","es":"Mozambique","fr":"Mozambique","ja":"モザンビーク","it":"Mozambico","zh-CN":"莫桑比克","tr":"Mozambik","ru":"Мозамбик","uk":"Мозамбік","pl":"Mozambik"}',
        -18.25000000,
        35.00000000,
        '🇲🇿',
        'U+1F1F2 U+1F1FF',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q1029'
    );

INSERT INTO
    public.countries
VALUES
    (
        151,
        'Myanmar',
        'MMR',
        '104',
        'MM',
        '95',
        'Nay Pyi Taw',
        'MMK',
        'Burmese kyat',
        'K',
        '.mm',
        'မြန်မာ',
        'Asia',
        3,
        'South-Eastern Asia',
        13,
        'Burmese',
        '[{"zoneName":"Asia/Yangon","gmtOffset":23400,"gmtOffsetName":"UTC+06:30","abbreviation":"MMT","tzName":"Myanmar Standard Time"}]',
        '{"ko":"미얀마","pt-BR":"Myanmar","pt":"Myanmar","nl":"Myanmar","hr":"Mijanmar","fa":"میانمار","de":"Myanmar","es":"Myanmar","fr":"Myanmar","ja":"ミャンマー","it":"Birmania","zh-CN":"缅甸","tr":"Myanmar","ru":"Мьянма","uk":"М''янма","pl":"Birma"}',
        22.00000000,
        98.00000000,
        '🇲🇲',
        'U+1F1F2 U+1F1F2',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q836'
    );

INSERT INTO
    public.countries
VALUES
    (
        152,
        'Namibia',
        'NAM',
        '516',
        'NA',
        '264',
        'Windhoek',
        'NAD',
        'Namibian dollar',
        '$',
        '.na',
        'Namibia',
        'Africa',
        1,
        'Southern Africa',
        5,
        'Namibian',
        '[{"zoneName":"Africa/Windhoek","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"WAST","tzName":"West Africa Summer Time"}]',
        '{"ko":"나미비아","pt-BR":"Namíbia","pt":"Namíbia","nl":"Namibië","hr":"Namibija","fa":"نامیبیا","de":"Namibia","es":"Namibia","fr":"Namibie","ja":"ナミビア","it":"Namibia","zh-CN":"纳米比亚","tr":"Namibya","ru":"Намибия","uk":"Намібія","pl":"Namibia"}',
        -22.00000000,
        17.00000000,
        '🇳🇦',
        'U+1F1F3 U+1F1E6',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q1030'
    );

INSERT INTO
    public.countries
VALUES
    (
        153,
        'Nauru',
        'NRU',
        '520',
        'NR',
        '674',
        'Yaren',
        'AUD',
        'Australian dollar',
        '$',
        '.nr',
        'Nauru',
        'Oceania',
        5,
        'Micronesia',
        21,
        'Nauruan',
        '[{"zoneName":"Pacific/Nauru","gmtOffset":43200,"gmtOffsetName":"UTC+12:00","abbreviation":"NRT","tzName":"Nauru Time"}]',
        '{"ko":"나우루","pt-BR":"Nauru","pt":"Nauru","nl":"Nauru","hr":"Nauru","fa":"نائورو","de":"Nauru","es":"Nauru","fr":"Nauru","ja":"ナウル","it":"Nauru","zh-CN":"瑙鲁","tr":"Nauru","ru":"Науру","uk":"Науру","pl":"Nauru"}',
        -0.53333333,
        166.91666666,
        '🇳🇷',
        'U+1F1F3 U+1F1F7',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q697'
    );

INSERT INTO
    public.countries
VALUES
    (
        154,
        'Nepal',
        'NPL',
        '524',
        'NP',
        '977',
        'Kathmandu',
        'NPR',
        'Nepalese rupee',
        '₨',
        '.np',
        'नपल',
        'Asia',
        3,
        'Southern Asia',
        14,
        'Nepali, Nepalese',
        '[{"zoneName":"Asia/Kathmandu","gmtOffset":20700,"gmtOffsetName":"UTC+05:45","abbreviation":"NPT","tzName":"Nepal Time"}]',
        '{"ko":"네팔","pt-BR":"Nepal","pt":"Nepal","nl":"Nepal","hr":"Nepal","fa":"نپال","de":"Népal","es":"Nepal","fr":"Népal","ja":"ネパール","it":"Nepal","zh-CN":"尼泊尔","tr":"Nepal","ru":"Непал","uk":"Непал","pl":"Nepal"}',
        28.00000000,
        84.00000000,
        '🇳🇵',
        'U+1F1F3 U+1F1F5',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q837'
    );

INSERT INTO
    public.countries
VALUES
    (
        156,
        'Netherlands',
        'NLD',
        '528',
        'NL',
        '31',
        'Amsterdam',
        'EUR',
        'Euro',
        '€',
        '.nl',
        'Nederland',
        'Europe',
        4,
        'Western Europe',
        17,
        'Dutch, Netherlandic',
        '[{"zoneName":"Europe/Amsterdam","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"네덜란드 ","pt-BR":"Holanda","pt":"Países Baixos","nl":"Nederland","hr":"Nizozemska","fa":"پادشاهی هلند","de":"Niederlande","es":"Países Bajos","fr":"Pays-Bas","ja":"オランダ","it":"Paesi Bassi","zh-CN":"荷兰","tr":"Hollanda","ru":"Нидерланды","uk":"Нідерланди","pl":"Holandia"}',
        52.50000000,
        5.75000000,
        '🇳🇱',
        'U+1F1F3 U+1F1F1',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q55'
    );

INSERT INTO
    public.countries
VALUES
    (
        157,
        'New Caledonia',
        'NCL',
        '540',
        'NC',
        '687',
        'Noumea',
        'XPF',
        'CFP franc',
        '₣',
        '.nc',
        'Nouvelle-Calédonie',
        'Oceania',
        5,
        'Melanesia',
        20,
        'New Caledonian',
        '[{"zoneName":"Pacific/Noumea","gmtOffset":39600,"gmtOffsetName":"UTC+11:00","abbreviation":"NCT","tzName":"New Caledonia Time"}]',
        '{"ko":"누벨칼레도니","pt-BR":"Nova Caledônia","pt":"Nova Caledónia","nl":"Nieuw-Caledonië","hr":"Nova Kaledonija","fa":"کالدونیای جدید","de":"Neukaledonien","es":"Nueva Caledonia","fr":"Nouvelle-Calédonie","ja":"ニューカレドニア","it":"Nuova Caledonia","zh-CN":"新喀里多尼亚","tr":"Yeni Kaledonya","ru":"Новая Каледония","uk":"Нова Каледонія","pl":"Nowa Kaledonia"}',
        -21.50000000,
        165.50000000,
        '🇳🇨',
        'U+1F1F3 U+1F1E8',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q33788'
    );

INSERT INTO
    public.countries
VALUES
    (
        158,
        'New Zealand',
        'NZL',
        '554',
        'NZ',
        '64',
        'Wellington',
        'NZD',
        'New Zealand dollar',
        '$',
        '.nz',
        'New Zealand',
        'Oceania',
        5,
        'Australia and New Zealand',
        19,
        'New Zealand, NZ',
        '[{"zoneName":"Pacific/Auckland","gmtOffset":46800,"gmtOffsetName":"UTC+13:00","abbreviation":"NZDT","tzName":"New Zealand Daylight Time"},{"zoneName":"Pacific/Chatham","gmtOffset":49500,"gmtOffsetName":"UTC+13:45","abbreviation":"CHAST","tzName":"Chatham Standard Time"}]',
        '{"ko":"뉴질랜드","pt-BR":"Nova Zelândia","pt":"Nova Zelândia","nl":"Nieuw-Zeeland","hr":"Novi Zeland","fa":"نیوزیلند","de":"Neuseeland","es":"Nueva Zelanda","fr":"Nouvelle-Zélande","ja":"ニュージーランド","it":"Nuova Zelanda","zh-CN":"新西兰","tr":"Yeni Zelanda","ru":"Новая Зеландия","uk":"Нова Зеландія","pl":"Nowa Zelandia"}',
        -41.00000000,
        174.00000000,
        '🇳🇿',
        'U+1F1F3 U+1F1FF',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q664'
    );

INSERT INTO
    public.countries
VALUES
    (
        159,
        'Nicaragua',
        'NIC',
        '558',
        'NI',
        '505',
        'Managua',
        'NIO',
        'Nicaraguan córdoba',
        'C$',
        '.ni',
        'Nicaragua',
        'Americas',
        2,
        'Central America',
        9,
        'Nicaraguan',
        '[{"zoneName":"America/Managua","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"}]',
        '{"ko":"니카라과","pt-BR":"Nicarágua","pt":"Nicarágua","nl":"Nicaragua","hr":"Nikaragva","fa":"نیکاراگوئه","de":"Nicaragua","es":"Nicaragua","fr":"Nicaragua","ja":"ニカラグア","it":"Nicaragua","zh-CN":"尼加拉瓜","tr":"Nikaragua","ru":"Никарагуа","uk":"Нікарагуа","pl":"Nikaragua"}',
        13.00000000,
        -85.00000000,
        '🇳🇮',
        'U+1F1F3 U+1F1EE',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q811'
    );

INSERT INTO
    public.countries
VALUES
    (
        160,
        'Niger',
        'NER',
        '562',
        'NE',
        '227',
        'Niamey',
        'XOF',
        'West African CFA franc',
        'CFA',
        '.ne',
        'Niger',
        'Africa',
        1,
        'Western Africa',
        3,
        'Nigerien',
        '[{"zoneName":"Africa/Niamey","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"WAT","tzName":"West Africa Time"}]',
        '{"ko":"니제르","pt-BR":"Níger","pt":"Níger","nl":"Niger","hr":"Niger","fa":"نیجر","de":"Niger","es":"Níger","fr":"Niger","ja":"ニジェール","it":"Niger","zh-CN":"尼日尔","tr":"Nijer","ru":"Нигер","uk":"Нігер","pl":"Niger"}',
        16.00000000,
        8.00000000,
        '🇳🇪',
        'U+1F1F3 U+1F1EA',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q1032'
    );

INSERT INTO
    public.countries
VALUES
    (
        161,
        'Nigeria',
        'NGA',
        '566',
        'NG',
        '234',
        'Abuja',
        'NGN',
        'Nigerian naira',
        '₦',
        '.ng',
        'Nigeria',
        'Africa',
        1,
        'Western Africa',
        3,
        'Nigerian',
        '[{"zoneName":"Africa/Lagos","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"WAT","tzName":"West Africa Time"}]',
        '{"ko":"나이지리아","pt-BR":"Nigéria","pt":"Nigéria","nl":"Nigeria","hr":"Nigerija","fa":"نیجریه","de":"Nigeria","es":"Nigeria","fr":"Nigéria","ja":"ナイジェリア","it":"Nigeria","zh-CN":"尼日利亚","tr":"Nijerya","ru":"Нигерия","uk":"Нігерія","pl":"Nigeria"}',
        10.00000000,
        8.00000000,
        '🇳🇬',
        'U+1F1F3 U+1F1EC',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q1033'
    );

INSERT INTO
    public.countries
VALUES
    (
        162,
        'Niue',
        'NIU',
        '570',
        'NU',
        '683',
        'Alofi',
        'NZD',
        'New Zealand dollar',
        '$',
        '.nu',
        'Niuē',
        'Oceania',
        5,
        'Polynesia',
        22,
        'Niuean',
        '[{"zoneName":"Pacific/Niue","gmtOffset":-39600,"gmtOffsetName":"UTC-11:00","abbreviation":"NUT","tzName":"Niue Time"}]',
        '{"ko":"니우에","pt-BR":"Niue","pt":"Niue","nl":"Niue","hr":"Niue","fa":"نیووی","de":"Niue","es":"Niue","fr":"Niue","ja":"ニウエ","it":"Niue","zh-CN":"纽埃","tr":"Niue","ru":"Ниуэ","uk":"Ніуе","pl":"Niue"}',
        -19.03333333,
        -169.86666666,
        '🇳🇺',
        'U+1F1F3 U+1F1FA',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q34020'
    );

INSERT INTO
    public.countries
VALUES
    (
        163,
        'Norfolk Island',
        'NFK',
        '574',
        'NF',
        '672',
        'Kingston',
        'AUD',
        'Australian dollar',
        '$',
        '.nf',
        'Norfolk Island',
        'Oceania',
        5,
        'Australia and New Zealand',
        19,
        'Norfolk Island',
        '[{"zoneName":"Pacific/Norfolk","gmtOffset":43200,"gmtOffsetName":"UTC+12:00","abbreviation":"NFT","tzName":"Norfolk Time"}]',
        '{"ko":"노퍽 섬","pt-BR":"Ilha Norfolk","pt":"Ilha Norfolk","nl":"Norfolkeiland","hr":"Otok Norfolk","fa":"جزیره نورفک","de":"Norfolkinsel","es":"Isla de Norfolk","fr":"Île de Norfolk","ja":"ノーフォーク島","it":"Isola Norfolk","zh-CN":"诺福克岛","tr":"Norfolk Adasi","ru":"Остров Норфолк","uk":"Острів Норфолк","pl":"Wyspa Norfolk"}',
        -29.03333333,
        167.95000000,
        '🇳🇫',
        'U+1F1F3 U+1F1EB',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q31057'
    );

INSERT INTO
    public.countries
VALUES
    (
        164,
        'Northern Mariana Islands',
        'MNP',
        '580',
        'MP',
        '1',
        'Saipan',
        'USD',
        'United States dollar',
        '$',
        '.mp',
        'Northern Mariana Islands',
        'Oceania',
        5,
        'Micronesia',
        21,
        'Northern Marianan',
        '[{"zoneName":"Pacific/Saipan","gmtOffset":36000,"gmtOffsetName":"UTC+10:00","abbreviation":"ChST","tzName":"Chamorro Standard Time"}]',
        '{"ko":"북마리아나 제도","pt-BR":"Ilhas Marianas","pt":"Ilhas Marianas","nl":"Noordelijke Marianeneilanden","hr":"Sjevernomarijanski otoci","fa":"جزایر ماریانای شمالی","de":"Nördliche Marianen","es":"Islas Marianas del Norte","fr":"Îles Mariannes du Nord","ja":"北マリアナ諸島","it":"Isole Marianne Settentrionali","zh-CN":"北马里亚纳群岛","tr":"Kuzey Mariana Adalari","ru":"Северные Марианские острова","uk":"Північні Маріанські острови","pl":"Mariany Północne"}',
        15.20000000,
        145.75000000,
        '🇲🇵',
        'U+1F1F2 U+1F1F5',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q16644'
    );

INSERT INTO
    public.countries
VALUES
    (
        165,
        'Norway',
        'NOR',
        '578',
        'NO',
        '47',
        'Oslo',
        'NOK',
        'Norwegian krone',
        'ko',
        '.no',
        'Norge',
        'Europe',
        4,
        'Northern Europe',
        18,
        'Norwegian',
        '[{"zoneName":"Europe/Oslo","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"노르웨이","pt-BR":"Noruega","pt":"Noruega","nl":"Noorwegen","hr":"Norveška","fa":"نروژ","de":"Norwegen","es":"Noruega","fr":"Norvège","ja":"ノルウェー","it":"Norvegia","zh-CN":"挪威","tr":"Norveç","ru":"Норвегия","uk":"Норвегія","pl":"Norwegia"}',
        62.00000000,
        10.00000000,
        '🇳🇴',
        'U+1F1F3 U+1F1F4',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q20'
    );

INSERT INTO
    public.countries
VALUES
    (
        166,
        'Oman',
        'OMN',
        '512',
        'OM',
        '968',
        'Muscat',
        'OMR',
        'Omani rial',
        '.ع.ر',
        '.om',
        'عمان',
        'Asia',
        3,
        'Western Asia',
        11,
        'Omani',
        '[{"zoneName":"Asia/Muscat","gmtOffset":14400,"gmtOffsetName":"UTC+04:00","abbreviation":"GST","tzName":"Gulf Standard Time"}]',
        '{"ko":"오만","pt-BR":"Omã","pt":"Omã","nl":"Oman","hr":"Oman","fa":"عمان","de":"Oman","es":"Omán","fr":"Oman","ja":"オマーン","it":"oman","zh-CN":"阿曼","tr":"Umman","ru":"Оман","uk":"Оман","pl":"Oman"}',
        21.00000000,
        57.00000000,
        '🇴🇲',
        'U+1F1F4 U+1F1F2',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q842'
    );

INSERT INTO
    public.countries
VALUES
    (
        167,
        'Pakistan',
        'PAK',
        '586',
        'PK',
        '92',
        'Islamabad',
        'PKR',
        'Pakistani rupee',
        '₨',
        '.pk',
        'پاکستان',
        'Asia',
        3,
        'Southern Asia',
        14,
        'Pakistani',
        '[{"zoneName":"Asia/Karachi","gmtOffset":18000,"gmtOffsetName":"UTC+05:00","abbreviation":"PKT","tzName":"Pakistan Standard Time"}]',
        '{"ko":"파키스탄","pt-BR":"Paquistão","pt":"Paquistão","nl":"Pakistan","hr":"Pakistan","fa":"پاکستان","de":"Pakistan","es":"Pakistán","fr":"Pakistan","ja":"パキスタン","it":"Pakistan","zh-CN":"巴基斯坦","tr":"Pakistan","ru":"Пакистан","uk":"Пакистан","pl":"Pakistan"}',
        30.00000000,
        70.00000000,
        '🇵🇰',
        'U+1F1F5 U+1F1F0',
        '2018-07-21 12:41:03',
        '2024-12-23 15:55:53',
        1,
        'Q843'
    );

INSERT INTO
    public.countries
VALUES
    (
        168,
        'Palau',
        'PLW',
        '585',
        'PW',
        '680',
        'Melekeok',
        'USD',
        'United States dollar',
        '$',
        '.pw',
        'Palau',
        'Oceania',
        5,
        'Micronesia',
        21,
        'Palauan',
        '[{"zoneName":"Pacific/Palau","gmtOffset":32400,"gmtOffsetName":"UTC+09:00","abbreviation":"PWT","tzName":"Palau Time"}]',
        '{"ko":"팔라우","pt-BR":"Palau","pt":"Palau","nl":"Palau","hr":"Palau","fa":"پالائو","de":"Palau","es":"Palau","fr":"Palaos","ja":"パラオ","it":"Palau","zh-CN":"帕劳","tr":"Palau","ru":"Палау","uk":"Палау","pl":"Palau"}',
        7.50000000,
        134.50000000,
        '🇵🇼',
        'U+1F1F5 U+1F1FC',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q695'
    );

INSERT INTO
    public.countries
VALUES
    (
        169,
        'Palestinian Territory Occupied',
        'PSE',
        '275',
        'PS',
        '970',
        'East Jerusalem',
        'ILS',
        'Israeli new shekel',
        '₪',
        '.ps',
        'فلسطين',
        'Asia',
        3,
        'Western Asia',
        11,
        'Palestinian',
        '[{"zoneName":"Asia/Gaza","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"},{"zoneName":"Asia/Hebron","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"팔레스타인 영토","pt-BR":"Palestina","pt":"Palestina","nl":"Palestijnse gebieden","hr":"Palestina","fa":"فلسطین","de":"Palästina","es":"Palestina","fr":"Palestine","ja":"パレスチナ","it":"Palestina","zh-CN":"巴勒斯坦","tr":"Filistin","ru":"Оккупированная палестинская территория","uk":"Окупована палестинська територія","pl":"Okupowane terytorium palestyńskie"}',
        31.90000000,
        35.20000000,
        '🇵🇸',
        'U+1F1F5 U+1F1F8',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        NULL
    );

INSERT INTO
    public.countries
VALUES
    (
        170,
        'Panama',
        'PAN',
        '591',
        'PA',
        '507',
        'Panama City',
        'PAB',
        'Panamanian balboa',
        'B/.',
        '.pa',
        'Panamá',
        'Americas',
        2,
        'Central America',
        9,
        'Panamanian',
        '[{"zoneName":"America/Panama","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"}]',
        '{"ko":"파나마","pt-BR":"Panamá","pt":"Panamá","nl":"Panama","hr":"Panama","fa":"پاناما","de":"Panama","es":"Panamá","fr":"Panama","ja":"パナマ","it":"Panama","zh-CN":"巴拿马","tr":"Panama","ru":"Панама","uk":"Панама","pl":"Panama"}',
        9.00000000,
        -80.00000000,
        '🇵🇦',
        'U+1F1F5 U+1F1E6',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q804'
    );

INSERT INTO
    public.countries
VALUES
    (
        171,
        'Papua New Guinea',
        'PNG',
        '598',
        'PG',
        '675',
        'Port Moresby',
        'PGK',
        'Papua New Guinean kina',
        'K',
        '.pg',
        'Papua Niugini',
        'Oceania',
        5,
        'Melanesia',
        20,
        'Papua New Guinean, Papuan',
        '[{"zoneName":"Pacific/Bougainville","gmtOffset":39600,"gmtOffsetName":"UTC+11:00","abbreviation":"BST","tzName":"Bougainville Standard Time[6"},{"zoneName":"Pacific/Port_Moresby","gmtOffset":36000,"gmtOffsetName":"UTC+10:00","abbreviation":"PGT","tzName":"Papua New Guinea Time"}]',
        '{"ko":"파푸아뉴기니","pt-BR":"Papua Nova Guiné","pt":"Papua Nova Guiné","nl":"Papoea-Nieuw-Guinea","hr":"Papua Nova Gvineja","fa":"پاپوآ گینه نو","de":"Papua-Neuguinea","es":"Papúa Nueva Guinea","fr":"Papouasie-Nouvelle-Guinée","ja":"パプアニューギニア","it":"Papua Nuova Guinea","zh-CN":"巴布亚新几内亚","tr":"Papua Yeni Gine","ru":"Папуа - Новая Гвинея","uk":"Папуа-Нова Гвінея","pl":"Papua-Nowa Gwinea"}',
        -6.00000000,
        147.00000000,
        '🇵🇬',
        'U+1F1F5 U+1F1EC',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q691'
    );

INSERT INTO
    public.countries
VALUES
    (
        172,
        'Paraguay',
        'PRY',
        '600',
        'PY',
        '595',
        'Asuncion',
        'PYG',
        'Paraguayan guarani',
        '₲',
        '.py',
        'Paraguay',
        'Americas',
        2,
        'South America',
        8,
        'Paraguayan',
        '[{"zoneName":"America/Asuncion","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"PYST","tzName":"Paraguay Summer Time"}]',
        '{"ko":"파라과이","pt-BR":"Paraguai","pt":"Paraguai","nl":"Paraguay","hr":"Paragvaj","fa":"پاراگوئه","de":"Paraguay","es":"Paraguay","fr":"Paraguay","ja":"パラグアイ","it":"Paraguay","zh-CN":"巴拉圭","tr":"Paraguay","ru":"Парагвай","uk":"Парагвай","pl":"Paragwaj"}',
        -23.00000000,
        -58.00000000,
        '🇵🇾',
        'U+1F1F5 U+1F1FE',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q733'
    );

INSERT INTO
    public.countries
VALUES
    (
        173,
        'Peru',
        'PER',
        '604',
        'PE',
        '51',
        'Lima',
        'PEN',
        'Peruvian sol',
        'S/.',
        '.pe',
        'Perú',
        'Americas',
        2,
        'South America',
        8,
        'Peruvian',
        '[{"zoneName":"America/Lima","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"PET","tzName":"Peru Time"}]',
        '{"ko":"페루","pt-BR":"Peru","pt":"Peru","nl":"Peru","hr":"Peru","fa":"پرو","de":"Peru","es":"Perú","fr":"Pérou","ja":"ペルー","it":"Perù","zh-CN":"秘鲁","tr":"Peru","ru":"Перу","uk":"Перу","pl":"Peru"}',
        -10.00000000,
        -76.00000000,
        '🇵🇪',
        'U+1F1F5 U+1F1EA',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q419'
    );

INSERT INTO
    public.countries
VALUES
    (
        174,
        'Philippines',
        'PHL',
        '608',
        'PH',
        '63',
        'Manila',
        'PHP',
        'Philippine peso',
        '₱',
        '.ph',
        'Pilipinas',
        'Asia',
        3,
        'South-Eastern Asia',
        13,
        'Philippine, Filipino',
        '[{"zoneName":"Asia/Manila","gmtOffset":28800,"gmtOffsetName":"UTC+08:00","abbreviation":"PHT","tzName":"Philippine Time"}]',
        '{"ko":"필리핀","pt-BR":"Filipinas","pt":"Filipinas","nl":"Filipijnen","hr":"Filipini","fa":"جزایر الندفیلیپین","de":"Philippinen","es":"Filipinas","fr":"Philippines","ja":"フィリピン","it":"Filippine","zh-CN":"菲律宾","tr":"Filipinler","ru":"Филиппины","uk":"Філіппіни","pl":"Filipiny"}',
        13.00000000,
        122.00000000,
        '🇵🇭',
        'U+1F1F5 U+1F1ED',
        '2018-07-21 12:41:03',
        '2023-08-11 21:15:55',
        1,
        'Q928'
    );

INSERT INTO
    public.countries
VALUES
    (
        175,
        'Pitcairn Island',
        'PCN',
        '612',
        'PN',
        '870',
        'Adamstown',
        'NZD',
        'New Zealand dollar',
        '$',
        '.pn',
        'Pitcairn Islands',
        'Oceania',
        5,
        'Polynesia',
        22,
        'Pitcairn Island',
        '[{"zoneName":"Pacific/Pitcairn","gmtOffset":-28800,"gmtOffsetName":"UTC-08:00","abbreviation":"PST","tzName":"Pacific Standard Time (North America"}]',
        '{"ko":"핏케언 제도","pt-BR":"Ilhas Pitcairn","pt":"Ilhas Picárnia","nl":"Pitcairneilanden","hr":"Pitcairnovo otočje","fa":"پیتکرن","de":"Pitcairn","es":"Islas Pitcairn","fr":"Îles Pitcairn","ja":"ピトケアン","it":"Isole Pitcairn","zh-CN":"皮特凯恩群岛","tr":"Pitcairn Adalari","ru":"Остров Питкэрн","uk":"Острів Піткерн","pl":"Wyspa Pitcairn"}',
        -25.06666666,
        -130.10000000,
        '🇵🇳',
        'U+1F1F5 U+1F1F3',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q1779748'
    );

INSERT INTO
    public.countries
VALUES
    (
        176,
        'Poland',
        'POL',
        '616',
        'PL',
        '48',
        'Warsaw',
        'PLN',
        'Polish złoty',
        'zł',
        '.pl',
        'Polska',
        'Europe',
        4,
        'Eastern Europe',
        15,
        'Polish',
        '[{"zoneName":"Europe/Warsaw","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"폴란드","pt-BR":"Polônia","pt":"Polónia","nl":"Polen","hr":"Poljska","fa":"لهستان","de":"Polen","es":"Polonia","fr":"Pologne","ja":"ポーランド","it":"Polonia","zh-CN":"波兰","tr":"Polonya","ru":"Польша","uk":"Польща","pl":"Polska"}',
        52.00000000,
        20.00000000,
        '🇵🇱',
        'U+1F1F5 U+1F1F1',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q36'
    );

INSERT INTO
    public.countries
VALUES
    (
        177,
        'Portugal',
        'PRT',
        '620',
        'PT',
        '351',
        'Lisbon',
        'EUR',
        'Euro',
        '€',
        '.pt',
        'Portugal',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Portuguese',
        '[{"zoneName":"Atlantic/Azores","gmtOffset":-3600,"gmtOffsetName":"UTC-01:00","abbreviation":"AZOT","tzName":"Azores Standard Time"},{"zoneName":"Atlantic/Madeira","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"WET","tzName":"Western European Time"},{"zoneName":"Europe/Lisbon","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"WET","tzName":"Western European Time"}]',
        '{"ko":"포르투갈","pt-BR":"Portugal","pt":"Portugal","nl":"Portugal","hr":"Portugal","fa":"پرتغال","de":"Portugal","es":"Portugal","fr":"Portugal","ja":"ポルトガル","it":"Portogallo","zh-CN":"葡萄牙","tr":"Portekiz","ru":"Португалия","uk":"Португалія","pl":"Portugalia"}',
        39.50000000,
        -8.00000000,
        '🇵🇹',
        'U+1F1F5 U+1F1F9',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q45'
    );

INSERT INTO
    public.countries
VALUES
    (
        178,
        'Puerto Rico',
        'PRI',
        '630',
        'PR',
        '1',
        'San Juan',
        'USD',
        'United States dollar',
        '$',
        '.pr',
        'Puerto Rico',
        'Americas',
        2,
        'Caribbean',
        7,
        'Puerto Rican',
        '[{"zoneName":"America/Puerto_Rico","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"푸에르토리코","pt-BR":"Porto Rico","pt":"Porto Rico","nl":"Puerto Rico","hr":"Portoriko","fa":"پورتو ریکو","de":"Puerto Rico","es":"Puerto Rico","fr":"Porto Rico","ja":"プエルトリコ","it":"Porto Rico","zh-CN":"波多黎各","tr":"Porto Riko","ru":"Пуэрто-Рико","uk":"Пуерто-Ріко","pl":"Portoryko"}',
        18.25000000,
        -66.50000000,
        '🇵🇷',
        'U+1F1F5 U+1F1F7',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q1183'
    );

INSERT INTO
    public.countries
VALUES
    (
        179,
        'Qatar',
        'QAT',
        '634',
        'QA',
        '974',
        'Doha',
        'QAR',
        'Qatari riyal',
        'ق.ر',
        '.qa',
        'قطر',
        'Asia',
        3,
        'Western Asia',
        11,
        'Qatari',
        '[{"zoneName":"Asia/Qatar","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"AST","tzName":"Arabia Standard Time"}]',
        '{"ko":"카타르","pt-BR":"Catar","pt":"Catar","nl":"Qatar","hr":"Katar","fa":"قطر","de":"Katar","es":"Catar","fr":"Qatar","ja":"カタール","it":"Qatar","zh-CN":"卡塔尔","tr":"Katar","ru":"Катар","uk":"Катар","pl":"Katar"}',
        25.50000000,
        51.25000000,
        '🇶🇦',
        'U+1F1F6 U+1F1E6',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q846'
    );

INSERT INTO
    public.countries
VALUES
    (
        180,
        'Reunion',
        'REU',
        '638',
        'RE',
        '262',
        'Saint-Denis',
        'EUR',
        'Euro',
        '€',
        '.re',
        'La Réunion',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Reunionese, Reunionnais',
        '[{"zoneName":"Indian/Reunion","gmtOffset":14400,"gmtOffsetName":"UTC+04:00","abbreviation":"RET","tzName":"Réunion Time"}]',
        '{"ko":"레위니옹","pt-BR":"Reunião","pt":"Reunião","nl":"Réunion","hr":"Réunion","fa":"رئونیون","de":"Réunion","es":"Reunión","fr":"Réunion","ja":"レユニオン","it":"Riunione","zh-CN":"留尼汪岛","tr":"Réunion","ru":"Воссоединение","uk":"Возз''єднання","pl":"Reunion"}',
        -21.15000000,
        55.50000000,
        '🇷🇪',
        'U+1F1F7 U+1F1EA',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q293585'
    );

INSERT INTO
    public.countries
VALUES
    (
        181,
        'Romania',
        'ROU',
        '642',
        'RO',
        '40',
        'Bucharest',
        'RON',
        'Romanian leu',
        'lei',
        '.ro',
        'România',
        'Europe',
        4,
        'Eastern Europe',
        15,
        'Romanian',
        '[{"zoneName":"Europe/Bucharest","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"루마니아","pt-BR":"Romênia","pt":"Roménia","nl":"Roemenië","hr":"Rumunjska","fa":"رومانی","de":"Rumänien","es":"Rumania","fr":"Roumanie","ja":"ルーマニア","it":"Romania","zh-CN":"罗马尼亚","tr":"Romanya","ru":"Румыния","uk":"Румунія","pl":"Rumunia"}',
        46.00000000,
        25.00000000,
        '🇷🇴',
        'U+1F1F7 U+1F1F4',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q218'
    );

INSERT INTO
    public.countries
VALUES
    (
        182,
        'Russia',
        'RUS',
        '643',
        'RU',
        '7',
        'Moscow',
        'RUB',
        'Russian ruble',
        '₽',
        '.ru',
        'Россия',
        'Europe',
        4,
        'Eastern Europe',
        15,
        'Russian',
        '[{"zoneName":"Asia/Anadyr","gmtOffset":43200,"gmtOffsetName":"UTC+12:00","abbreviation":"ANAT","tzName":"Anadyr Time[4"},{"zoneName":"Asia/Barnaul","gmtOffset":25200,"gmtOffsetName":"UTC+07:00","abbreviation":"KRAT","tzName":"Krasnoyarsk Time"},{"zoneName":"Asia/Chita","gmtOffset":32400,"gmtOffsetName":"UTC+09:00","abbreviation":"YAKT","tzName":"Yakutsk Time"},{"zoneName":"Asia/Irkutsk","gmtOffset":28800,"gmtOffsetName":"UTC+08:00","abbreviation":"IRKT","tzName":"Irkutsk Time"},{"zoneName":"Asia/Kamchatka","gmtOffset":43200,"gmtOffsetName":"UTC+12:00","abbreviation":"PETT","tzName":"Kamchatka Time"},{"zoneName":"Asia/Khandyga","gmtOffset":32400,"gmtOffsetName":"UTC+09:00","abbreviation":"YAKT","tzName":"Yakutsk Time"},{"zoneName":"Asia/Krasnoyarsk","gmtOffset":25200,"gmtOffsetName":"UTC+07:00","abbreviation":"KRAT","tzName":"Krasnoyarsk Time"},{"zoneName":"Asia/Magadan","gmtOffset":39600,"gmtOffsetName":"UTC+11:00","abbreviation":"MAGT","tzName":"Magadan Time"},{"zoneName":"Asia/Novokuznetsk","gmtOffset":25200,"gmtOffsetName":"UTC+07:00","abbreviation":"KRAT","tzName":"Krasnoyarsk Time"},{"zoneName":"Asia/Novosibirsk","gmtOffset":25200,"gmtOffsetName":"UTC+07:00","abbreviation":"NOVT","tzName":"Novosibirsk Time"},{"zoneName":"Asia/Omsk","gmtOffset":21600,"gmtOffsetName":"UTC+06:00","abbreviation":"OMST","tzName":"Omsk Time"},{"zoneName":"Asia/Sakhalin","gmtOffset":39600,"gmtOffsetName":"UTC+11:00","abbreviation":"SAKT","tzName":"Sakhalin Island Time"},{"zoneName":"Asia/Srednekolymsk","gmtOffset":39600,"gmtOffsetName":"UTC+11:00","abbreviation":"SRET","tzName":"Srednekolymsk Time"},{"zoneName":"Asia/Tomsk","gmtOffset":25200,"gmtOffsetName":"UTC+07:00","abbreviation":"MSD+3","tzName":"Moscow Daylight Time+3"},{"zoneName":"Asia/Ust-Nera","gmtOffset":36000,"gmtOffsetName":"UTC+10:00","abbreviation":"VLAT","tzName":"Vladivostok Time"},{"zoneName":"Asia/Vladivostok","gmtOffset":36000,"gmtOffsetName":"UTC+10:00","abbreviation":"VLAT","tzName":"Vladivostok Time"},{"zoneName":"Asia/Yakutsk","gmtOffset":32400,"gmtOffsetName":"UTC+09:00","abbreviation":"YAKT","tzName":"Yakutsk Time"},{"zoneName":"Asia/Yekaterinburg","gmtOffset":18000,"gmtOffsetName":"UTC+05:00","abbreviation":"YEKT","tzName":"Yekaterinburg Time"},{"zoneName":"Europe/Astrakhan","gmtOffset":14400,"gmtOffsetName":"UTC+04:00","abbreviation":"SAMT","tzName":"Samara Time"},{"zoneName":"Europe/Kaliningrad","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"},{"zoneName":"Europe/Kirov","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"MSK","tzName":"Moscow Time"},{"zoneName":"Europe/Moscow","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"MSK","tzName":"Moscow Time"},{"zoneName":"Europe/Samara","gmtOffset":14400,"gmtOffsetName":"UTC+04:00","abbreviation":"SAMT","tzName":"Samara Time"},{"zoneName":"Europe/Saratov","gmtOffset":14400,"gmtOffsetName":"UTC+04:00","abbreviation":"MSD","tzName":"Moscow Daylight Time+4"},{"zoneName":"Europe/Ulyanovsk","gmtOffset":14400,"gmtOffsetName":"UTC+04:00","abbreviation":"SAMT","tzName":"Samara Time"},{"zoneName":"Europe/Volgograd","gmtOffset":14400,"gmtOffsetName":"UTC+04:00","abbreviation":"MSK","tzName":"Moscow Standard Time"}]',
        '{"ko":"러시아","pt-BR":"Rússia","pt":"Rússia","nl":"Rusland","hr":"Rusija","fa":"روسیه","de":"Russland","es":"Rusia","fr":"Russie","ja":"ロシア連邦","it":"Russia","zh-CN":"俄罗斯联邦","tr":"Rusya","ru":"Россия","uk":"Росія","pl":"Rosja"}',
        60.00000000,
        100.00000000,
        '🇷🇺',
        'U+1F1F7 U+1F1FA',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q159'
    );

INSERT INTO
    public.countries
VALUES
    (
        183,
        'Rwanda',
        'RWA',
        '646',
        'RW',
        '250',
        'Kigali',
        'RWF',
        'Rwandan franc',
        'FRw',
        '.rw',
        'Rwanda',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Rwandan',
        '[{"zoneName":"Africa/Kigali","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"CAT","tzName":"Central Africa Time"}]',
        '{"ko":"르완다","pt-BR":"Ruanda","pt":"Ruanda","nl":"Rwanda","hr":"Ruanda","fa":"رواندا","de":"Ruanda","es":"Ruanda","fr":"Rwanda","ja":"ルワンダ","it":"Ruanda","zh-CN":"卢旺达","tr":"Ruanda","ru":"Руанда","uk":"Руанда","pl":"Rwanda"}',
        -2.00000000,
        30.00000000,
        '🇷🇼',
        'U+1F1F7 U+1F1FC',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q1037'
    );

INSERT INTO
    public.countries
VALUES
    (
        184,
        'Saint Helena',
        'SHN',
        '654',
        'SH',
        '290',
        'Jamestown',
        'SHP',
        'Saint Helena pound',
        '£',
        '.sh',
        'Saint Helena',
        'Africa',
        1,
        'Western Africa',
        3,
        'Saint Helenian',
        '[{"zoneName":"Atlantic/St_Helena","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"세인트헬레나","pt-BR":"Santa Helena","pt":"Santa Helena","nl":"Sint-Helena","hr":"Sveta Helena","fa":"سنت هلنا، اسنشن و تریستان دا کونا","de":"Sankt Helena","es":"Santa Helena","fr":"Sainte-Hélène","ja":"セントヘレナ・アセンションおよびトリスタンダクーニャ","it":"Sant''Elena","zh-CN":"圣赫勒拿","tr":"Saint Helena","ru":"Святая Елена","uk":"Свята Єлена","pl":"Święta Helena"}',
        -15.95000000,
        -5.70000000,
        '🇸🇭',
        'U+1F1F8 U+1F1ED',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q34497'
    );

INSERT INTO
    public.countries
VALUES
    (
        185,
        'Saint Kitts and Nevis',
        'KNA',
        '659',
        'KN',
        '1',
        'Basseterre',
        'XCD',
        'Eastern Caribbean dollar',
        '$',
        '.kn',
        'Saint Kitts and Nevis',
        'Americas',
        2,
        'Caribbean',
        7,
        'Kittitian or Nevisian',
        '[{"zoneName":"America/St_Kitts","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"세인트키츠 네비스","pt-BR":"São Cristóvão e Neves","pt":"São Cristóvão e Neves","nl":"Saint Kitts en Nevis","hr":"Sveti Kristof i Nevis","fa":"سنت کیتس و نویس","de":"St. Kitts und Nevis","es":"San Cristóbal y Nieves","fr":"Saint-Christophe-et-Niévès","ja":"セントクリストファー・ネイビス","it":"Saint Kitts e Nevis","zh-CN":"圣基茨和尼维斯","tr":"Saint Kitts Ve Nevis","ru":"Сент-Китс и Невис","uk":"Сент-Кітс і Невіс","pl":"Saint Kitts i Nevis"}',
        17.33333333,
        -62.75000000,
        '🇰🇳',
        'U+1F1F0 U+1F1F3',
        '2018-07-21 12:41:03',
        '2024-09-05 16:47:03',
        1,
        'Q763'
    );

INSERT INTO
    public.countries
VALUES
    (
        186,
        'Saint Lucia',
        'LCA',
        '662',
        'LC',
        '1',
        'Castries',
        'XCD',
        'Eastern Caribbean dollar',
        '$',
        '.lc',
        'Saint Lucia',
        'Americas',
        2,
        'Caribbean',
        7,
        'Saint Lucian',
        '[{"zoneName":"America/St_Lucia","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"세인트루시아","pt-BR":"Santa Lúcia","pt":"Santa Lúcia","nl":"Saint Lucia","hr":"Sveta Lucija","fa":"سنت لوسیا","de":"Saint Lucia","es":"Santa Lucía","fr":"Saint-Lucie","ja":"セントルシア","it":"Santa Lucia","zh-CN":"圣卢西亚","tr":"Saint Lucia","ru":"Сент-Люсия","uk":"Сент-Люсія","pl":"Saint Lucia"}',
        13.88333333,
        -60.96666666,
        '🇱🇨',
        'U+1F1F1 U+1F1E8',
        '2018-07-21 12:41:03',
        '2024-09-05 16:47:03',
        1,
        'Q760'
    );

INSERT INTO
    public.countries
VALUES
    (
        187,
        'Saint Pierre and Miquelon',
        'SPM',
        '666',
        'PM',
        '508',
        'Saint-Pierre',
        'EUR',
        'Euro',
        '€',
        '.pm',
        'Saint-Pierre-et-Miquelon',
        'Americas',
        2,
        'Northern America',
        6,
        'Saint-Pierrais or Miquelonnais',
        '[{"zoneName":"America/Miquelon","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"PMDT","tzName":"Pierre & Miquelon Daylight Time"}]',
        '{"ko":"생피에르 미클롱","pt-BR":"Saint-Pierre e Miquelon","pt":"São Pedro e Miquelon","nl":"Saint Pierre en Miquelon","hr":"Sveti Petar i Mikelon","fa":"سن پیر و میکلن","de":"Saint-Pierre und Miquelon","es":"San Pedro y Miquelón","fr":"Saint-Pierre-et-Miquelon","ja":"サンピエール島・ミクロン島","it":"Saint-Pierre e Miquelon","zh-CN":"圣皮埃尔和密克隆","tr":"Saint Pierre Ve Miquelon","ru":"Сен-Пьер и Микелон","uk":"Сен-П''єр і Мікелон","pl":"Saint-Pierre i Miquelon"}',
        46.83333333,
        -56.33333333,
        '🇵🇲',
        'U+1F1F5 U+1F1F2',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q34617'
    );

INSERT INTO
    public.countries
VALUES
    (
        188,
        'Saint Vincent and the Grenadines',
        'VCT',
        '670',
        'VC',
        '1',
        'Kingstown',
        'XCD',
        'Eastern Caribbean dollar',
        '$',
        '.vc',
        'Saint Vincent and the Grenadines',
        'Americas',
        2,
        'Caribbean',
        7,
        'Saint Vincentian, Vincentian',
        '[{"zoneName":"America/St_Vincent","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"세인트빈센트 그레나딘","pt-BR":"São Vicente e Granadinas","pt":"São Vicente e Granadinas","nl":"Saint Vincent en de Grenadines","hr":"Sveti Vincent i Grenadini","fa":"سنت وینسنت و گرنادین‌ها","de":"Saint Vincent und die Grenadinen","es":"San Vicente y Granadinas","fr":"Saint-Vincent-et-les-Grenadines","ja":"セントビンセントおよびグレナディーン諸島","it":"Saint Vincent e Grenadine","zh-CN":"圣文森特和格林纳丁斯","tr":"Saint Vincent Ve Grenadinler","ru":"Сент-Винсент и Гренадины","uk":"Сент-Вінсент і Гренадини","pl":"Saint Vincent i Grenadyny"}',
        13.25000000,
        -61.20000000,
        '🇻🇨',
        'U+1F1FB U+1F1E8',
        '2018-07-21 12:41:03',
        '2024-09-05 16:47:03',
        1,
        'Q757'
    );

INSERT INTO
    public.countries
VALUES
    (
        189,
        'Saint-Barthelemy',
        'BLM',
        '652',
        'BL',
        '590',
        'Gustavia',
        'EUR',
        'Euro',
        '€',
        '.bl',
        'Saint-Barthélemy',
        'Americas',
        2,
        'Caribbean',
        7,
        'Barthelemois',
        '[{"zoneName":"America/St_Barthelemy","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"생바르텔레미","pt-BR":"São Bartolomeu","pt":"São Bartolomeu","nl":"Saint Barthélemy","hr":"Saint Barthélemy","fa":"سن-بارتلمی","de":"Saint-Barthélemy","es":"San Bartolomé","fr":"Saint-Barthélemy","ja":"サン・バルテルミー","it":"Antille Francesi","zh-CN":"圣巴泰勒米","tr":"Saint Barthélemy","ru":"Сен-Бартелеми","uk":"Сен-Бартелемі","pl":"Saint-Barthelemy"}',
        18.50000000,
        -63.41666666,
        '🇧🇱',
        'U+1F1E7 U+1F1F1',
        '2018-07-21 12:41:03',
        '2024-12-19 21:00:55',
        1,
        'Q25362'
    );

INSERT INTO
    public.countries
VALUES
    (
        190,
        'Saint-Martin (French part)',
        'MAF',
        '663',
        'MF',
        '590',
        'Marigot',
        'EUR',
        'Euro',
        '€',
        '.mf',
        'Saint-Martin',
        'Americas',
        2,
        'Caribbean',
        7,
        'Saint-Martinoise',
        '[{"zoneName":"America/Marigot","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"세인트마틴 섬","pt-BR":"Saint Martin","pt":"Ilha São Martinho","nl":"Saint-Martin","hr":"Sveti Martin","fa":"سینت مارتن","de":"Saint Martin","es":"Saint Martin","fr":"Saint-Martin","ja":"サン・マルタン（フランス領）","it":"Saint Martin","zh-CN":"密克罗尼西亚","tr":"Saint Martin","ru":"Сен-Мартен (французская часть)","uk":"Сен-Мартен (французька частина)","pl":"Saint-Martin (część francuska)"}',
        18.08333333,
        -63.95000000,
        '🇲🇫',
        'U+1F1F2 U+1F1EB',
        '2018-07-21 12:41:03',
        '2023-08-11 21:15:55',
        1,
        NULL
    );

INSERT INTO
    public.countries
VALUES
    (
        191,
        'Samoa',
        'WSM',
        '882',
        'WS',
        '685',
        'Apia',
        'WST',
        'Samoan tālā',
        'SAT',
        '.ws',
        'Samoa',
        'Oceania',
        5,
        'Polynesia',
        22,
        'Samoan',
        '[{"zoneName":"Pacific/Apia","gmtOffset":50400,"gmtOffsetName":"UTC+14:00","abbreviation":"WST","tzName":"West Samoa Time"}]',
        '{"ko":"사모아","pt-BR":"Samoa","pt":"Samoa","nl":"Samoa","hr":"Samoa","fa":"ساموآ","de":"Samoa","es":"Samoa","fr":"Samoa","ja":"サモア","it":"Samoa","zh-CN":"萨摩亚","tr":"Samoa","ru":"Самоа","uk":"Самоа","pl":"Samoa"}',
        -13.58333333,
        -172.33333333,
        '🇼🇸',
        'U+1F1FC U+1F1F8',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q683'
    );

INSERT INTO
    public.countries
VALUES
    (
        192,
        'San Marino',
        'SMR',
        '674',
        'SM',
        '378',
        'San Marino',
        'EUR',
        'Euro',
        '€',
        '.sm',
        'San Marino',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Sammarinese',
        '[{"zoneName":"Europe/San_Marino","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"산마리노","pt-BR":"San Marino","pt":"São Marinho","nl":"San Marino","hr":"San Marino","fa":"سان مارینو","de":"San Marino","es":"San Marino","fr":"Saint-Marin","ja":"サンマリノ","it":"San Marino","zh-CN":"圣马力诺","tr":"San Marino","ru":"Сан-Марино","uk":"Сан-Марино","pl":"San Marino"}',
        43.76666666,
        12.41666666,
        '🇸🇲',
        'U+1F1F8 U+1F1F2',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q238'
    );

INSERT INTO
    public.countries
VALUES
    (
        193,
        'Sao Tome and Principe',
        'STP',
        '678',
        'ST',
        '239',
        'Sao Tome',
        'STN',
        'Dobra',
        'Db',
        '.st',
        'São Tomé e Príncipe',
        'Africa',
        1,
        'Middle Africa',
        2,
        'Sao Tomean',
        '[{"zoneName":"Africa/Sao_Tome","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"상투메 프린시페","pt-BR":"São Tomé e Príncipe","pt":"São Tomé e Príncipe","nl":"Sao Tomé en Principe","hr":"Sveti Toma i Princip","fa":"کواترو دو فرویرو","de":"São Tomé und Príncipe","es":"Santo Tomé y Príncipe","fr":"Sao Tomé-et-Principe","ja":"サントメ・プリンシペ","it":"São Tomé e Príncipe","zh-CN":"圣多美和普林西比","tr":"Sao Tome Ve Prinsipe","ru":"Сан-Томе и Принсипи","uk":"Сан-Томе і Принсіпі","pl":"Wyspy Świętego Tomasza i Książęca"}',
        1.00000000,
        7.00000000,
        '🇸🇹',
        'U+1F1F8 U+1F1F9',
        '2018-07-21 12:41:03',
        '2025-03-22 20:09:58',
        1,
        'Q1039'
    );

INSERT INTO
    public.countries
VALUES
    (
        194,
        'Saudi Arabia',
        'SAU',
        '682',
        'SA',
        '966',
        'Riyadh',
        'SAR',
        'Saudi riyal',
        '﷼',
        '.sa',
        'المملكة العربية السعودية',
        'Asia',
        3,
        'Western Asia',
        11,
        'Saudi, Saudi Arabian',
        '[{"zoneName":"Asia/Riyadh","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"AST","tzName":"Arabia Standard Time"}]',
        '{"ko":"사우디아라비아","pt-BR":"Arábia Saudita","pt":"Arábia Saudita","nl":"Saoedi-Arabië","hr":"Saudijska Arabija","fa":"عربستان سعودی","de":"Saudi-Arabien","es":"Arabia Saudí","fr":"Arabie Saoudite","ja":"サウジアラビア","it":"Arabia Saudita","zh-CN":"沙特阿拉伯","tr":"Suudi Arabistan","ru":"Саудовская Аравия","uk":"Саудівська Аравія","pl":"Arabia Saudyjska"}',
        25.00000000,
        45.00000000,
        '🇸🇦',
        'U+1F1F8 U+1F1E6',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q851'
    );

INSERT INTO
    public.countries
VALUES
    (
        195,
        'Senegal',
        'SEN',
        '686',
        'SN',
        '221',
        'Dakar',
        'XOF',
        'West African CFA franc',
        'CFA',
        '.sn',
        'Sénégal',
        'Africa',
        1,
        'Western Africa',
        3,
        'Senegalese',
        '[{"zoneName":"Africa/Dakar","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"세네갈","pt-BR":"Senegal","pt":"Senegal","nl":"Senegal","hr":"Senegal","fa":"سنگال","de":"Senegal","es":"Senegal","fr":"Sénégal","ja":"セネガル","it":"Senegal","zh-CN":"塞内加尔","tr":"Senegal","ru":"Сенегал","uk":"Сенегал","pl":"Senegal"}',
        14.00000000,
        -14.00000000,
        '🇸🇳',
        'U+1F1F8 U+1F1F3',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q1041'
    );

INSERT INTO
    public.countries
VALUES
    (
        196,
        'Serbia',
        'SRB',
        '688',
        'RS',
        '381',
        'Belgrade',
        'RSD',
        'Serbian dinar',
        'din',
        '.rs',
        'Србија',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Serbian',
        '[{"zoneName":"Europe/Belgrade","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"세르비아","pt-BR":"Sérvia","pt":"Sérvia","nl":"Servië","hr":"Srbija","fa":"صربستان","de":"Serbien","es":"Serbia","fr":"Serbie","ja":"セルビア","it":"Serbia","zh-CN":"塞尔维亚","tr":"Sirbistan","ru":"Сербия","uk":"Сербія","pl":"Serbia"}',
        44.00000000,
        21.00000000,
        '🇷🇸',
        'U+1F1F7 U+1F1F8',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q403'
    );

INSERT INTO
    public.countries
VALUES
    (
        197,
        'Seychelles',
        'SYC',
        '690',
        'SC',
        '248',
        'Victoria',
        'SCR',
        'Seychellois rupee',
        'SRe',
        '.sc',
        'Seychelles',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Seychellois',
        '[{"zoneName":"Indian/Mahe","gmtOffset":14400,"gmtOffsetName":"UTC+04:00","abbreviation":"SCT","tzName":"Seychelles Time"}]',
        '{"ko":"세이셸","pt-BR":"Seicheles","pt":"Seicheles","nl":"Seychellen","hr":"Sejšeli","fa":"سیشل","de":"Seychellen","es":"Seychelles","fr":"Seychelles","ja":"セーシェル","it":"Seychelles","zh-CN":"塞舌尔","tr":"Seyşeller","ru":"Сейшельские острова","uk":"Сейшельські острови","pl":"Seszele"}',
        -4.58333333,
        55.66666666,
        '🇸🇨',
        'U+1F1F8 U+1F1E8',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q1042'
    );

INSERT INTO
    public.countries
VALUES
    (
        198,
        'Sierra Leone',
        'SLE',
        '694',
        'SL',
        '232',
        'Freetown',
        'SLL',
        'Sierra Leonean leone',
        'Le',
        '.sl',
        'Sierra Leone',
        'Africa',
        1,
        'Western Africa',
        3,
        'Sierra Leonean',
        '[{"zoneName":"Africa/Freetown","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"시에라리온","pt-BR":"Serra Leoa","pt":"Serra Leoa","nl":"Sierra Leone","hr":"Sijera Leone","fa":"سیرالئون","de":"Sierra Leone","es":"Sierra Leone","fr":"Sierra Leone","ja":"シエラレオネ","it":"Sierra Leone","zh-CN":"塞拉利昂","tr":"Sierra Leone","ru":"Сьерра-Леоне","uk":"Сьєрра-Леоне","pl":"Sierra Leone"}',
        8.50000000,
        -11.50000000,
        '🇸🇱',
        'U+1F1F8 U+1F1F1',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q1044'
    );

INSERT INTO
    public.countries
VALUES
    (
        199,
        'Singapore',
        'SGP',
        '702',
        'SG',
        '65',
        'Singapur',
        'SGD',
        'Singapore dollar',
        '$',
        '.sg',
        'Singapore',
        'Asia',
        3,
        'South-Eastern Asia',
        13,
        'Singaporean',
        '[{"zoneName":"Asia/Singapore","gmtOffset":28800,"gmtOffsetName":"UTC+08:00","abbreviation":"SGT","tzName":"Singapore Time"}]',
        '{"ko":"싱가포르","pt-BR":"Singapura","pt":"Singapura","nl":"Singapore","hr":"Singapur","fa":"سنگاپور","de":"Singapur","es":"Singapur","fr":"Singapour","ja":"シンガポール","it":"Singapore","zh-CN":"新加坡","tr":"Singapur","ru":"Сингапур","uk":"Сінгапур","pl":"Singapur"}',
        1.36666666,
        103.80000000,
        '🇸🇬',
        'U+1F1F8 U+1F1EC',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q334'
    );

INSERT INTO
    public.countries
VALUES
    (
        200,
        'Slovakia',
        'SVK',
        '703',
        'SK',
        '421',
        'Bratislava',
        'EUR',
        'Euro',
        '€',
        '.sk',
        'Slovensko',
        'Europe',
        4,
        'Eastern Europe',
        15,
        'Slovak',
        '[{"zoneName":"Europe/Bratislava","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"슬로바키아","pt-BR":"Eslováquia","pt":"Eslováquia","nl":"Slowakije","hr":"Slovačka","fa":"اسلواکی","de":"Slowakei","es":"República Eslovaca","fr":"Slovaquie","ja":"スロバキア","it":"Slovacchia","zh-CN":"斯洛伐克","tr":"Slovakya","ru":"Словакия","uk":"Словаччина","pl":"Słowacja"}',
        48.66666666,
        19.50000000,
        '🇸🇰',
        'U+1F1F8 U+1F1F0',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q214'
    );

INSERT INTO
    public.countries
VALUES
    (
        201,
        'Slovenia',
        'SVN',
        '705',
        'SI',
        '386',
        'Ljubljana',
        'EUR',
        'Euro',
        '€',
        '.si',
        'Slovenija',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Slovenian, Slovene',
        '[{"zoneName":"Europe/Ljubljana","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"슬로베니아","pt-BR":"Eslovênia","pt":"Eslovénia","nl":"Slovenië","hr":"Slovenija","fa":"اسلوونی","de":"Slowenien","es":"Eslovenia","fr":"Slovénie","ja":"スロベニア","it":"Slovenia","zh-CN":"斯洛文尼亚","tr":"Slovenya","ru":"Словения","uk":"Словенія","pl":"Słowenia"}',
        46.11666666,
        14.81666666,
        '🇸🇮',
        'U+1F1F8 U+1F1EE',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q215'
    );

INSERT INTO
    public.countries
VALUES
    (
        202,
        'Solomon Islands',
        'SLB',
        '090',
        'SB',
        '677',
        'Honiara',
        'SBD',
        'Solomon Islands dollar',
        'Si$',
        '.sb',
        'Solomon Islands',
        'Oceania',
        5,
        'Melanesia',
        20,
        'Solomon Island',
        '[{"zoneName":"Pacific/Guadalcanal","gmtOffset":39600,"gmtOffsetName":"UTC+11:00","abbreviation":"SBT","tzName":"Solomon Islands Time"}]',
        '{"ko":"솔로몬 제도","pt-BR":"Ilhas Salomão","pt":"Ilhas Salomão","nl":"Salomonseilanden","hr":"Solomonski Otoci","fa":"جزایر سلیمان","de":"Salomonen","es":"Islas Salomón","fr":"Îles Salomon","ja":"ソロモン諸島","it":"Isole Salomone","zh-CN":"所罗门群岛","tr":"Solomon Adalari","ru":"Соломоновы острова","uk":"Соломонові острови","pl":"Wyspy Salomona"}',
        -8.00000000,
        159.00000000,
        '🇸🇧',
        'U+1F1F8 U+1F1E7',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q685'
    );

INSERT INTO
    public.countries
VALUES
    (
        203,
        'Somalia',
        'SOM',
        '706',
        'SO',
        '252',
        'Mogadishu',
        'SOS',
        'Somali shilling',
        'Sh.so.',
        '.so',
        'Soomaaliya',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Somali, Somalian',
        '[{"zoneName":"Africa/Mogadishu","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"EAT","tzName":"East Africa Time"}]',
        '{"ko":"소말리아","pt-BR":"Somália","pt":"Somália","nl":"Somalië","hr":"Somalija","fa":"سومالی","de":"Somalia","es":"Somalia","fr":"Somalie","ja":"ソマリア","it":"Somalia","zh-CN":"索马里","tr":"Somali","ru":"Сомали","uk":"Сомалі","pl":"Somalia"}',
        10.00000000,
        49.00000000,
        '🇸🇴',
        'U+1F1F8 U+1F1F4',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q1045'
    );

INSERT INTO
    public.countries
VALUES
    (
        204,
        'South Africa',
        'ZAF',
        '710',
        'ZA',
        '27',
        'Pretoria',
        'ZAR',
        'South African rand',
        'R',
        '.za',
        'South Africa',
        'Africa',
        1,
        'Southern Africa',
        5,
        'South African',
        '[{"zoneName":"Africa/Johannesburg","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"SAST","tzName":"South African Standard Time"}]',
        '{"ko":"남아프리카 공화국","pt-BR":"República Sul-Africana","pt":"República Sul-Africana","nl":"Zuid-Afrika","hr":"Južnoafrička Republika","fa":"آفریقای جنوبی","de":"Republik Südafrika","es":"República de Sudáfrica","fr":"Afrique du Sud","ja":"南アフリカ","it":"Sud Africa","zh-CN":"南非","tr":"Güney Afrika Cumhuriyeti","ru":"Южная Африка","uk":"Південна Африка","pl":"Republika Południowej Afryki"}',
        -29.00000000,
        24.00000000,
        '🇿🇦',
        'U+1F1FF U+1F1E6',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q258'
    );

INSERT INTO
    public.countries
VALUES
    (
        205,
        'South Georgia',
        'SGS',
        '239',
        'GS',
        '500',
        'Grytviken',
        'GBP',
        'British pound',
        '£',
        '.gs',
        'South Georgia',
        'Americas',
        2,
        'South America',
        8,
        'South Georgia or South Sandwich Islands',
        '[{"zoneName":"Atlantic/South_Georgia","gmtOffset":-7200,"gmtOffsetName":"UTC-02:00","abbreviation":"GST","tzName":"South Georgia and the South Sandwich Islands Time"}]',
        '{"ko":"사우스조지아","pt-BR":"Ilhas Geórgias do Sul e Sandwich do Sul","pt":"Ilhas Geórgia do Sul e Sanduíche do Sul","nl":"Zuid-Georgia en Zuidelijke Sandwicheilanden","hr":"Južna Georgija i otočje Južni Sandwich","fa":"جزایر جورجیای جنوبی و ساندویچ جنوبی","de":"Südgeorgien und die Südlichen Sandwichinseln","es":"Islas Georgias del Sur y Sandwich del Sur","fr":"Géorgie du Sud-et-les Îles Sandwich du Sud","ja":"サウスジョージア・サウスサンドウィッチ諸島","it":"Georgia del Sud e Isole Sandwich Meridionali","zh-CN":"南乔治亚","tr":"Güney Georgia","ru":"Южная Джорджия","uk":"Південна Джорджія","pl":"Południowa Georgia"}',
        -54.50000000,
        -37.00000000,
        '🇬🇸',
        'U+1F1EC U+1F1F8',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q1137202'
    );

INSERT INTO
    public.countries
VALUES
    (
        206,
        'South Sudan',
        'SSD',
        '728',
        'SS',
        '211',
        'Juba',
        'SSP',
        'South Sudanese pound',
        '£',
        '.ss',
        'South Sudan',
        'Africa',
        1,
        'Middle Africa',
        2,
        'South Sudanese',
        '[{"zoneName":"Africa/Juba","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"EAT","tzName":"East Africa Time"}]',
        '{"ko":"남수단","pt-BR":"Sudão do Sul","pt":"Sudão do Sul","nl":"Zuid-Soedan","hr":"Južni Sudan","fa":"سودان جنوبی","de":"Südsudan","es":"Sudán del Sur","fr":"Soudan du Sud","ja":"南スーダン","it":"Sudan del sud","zh-CN":"南苏丹","tr":"Güney Sudan","ru":"Южный Судан","uk":"Південний Судан","pl":"Sudan Południowy"}',
        7.00000000,
        30.00000000,
        '🇸🇸',
        'U+1F1F8 U+1F1F8',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q958'
    );

INSERT INTO
    public.countries
VALUES
    (
        207,
        'Spain',
        'ESP',
        '724',
        'ES',
        '34',
        'Madrid',
        'EUR',
        'Euro',
        '€',
        '.es',
        'España',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Spanish',
        '[{"zoneName":"Africa/Ceuta","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"},{"zoneName":"Atlantic/Canary","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"WET","tzName":"Western European Time"},{"zoneName":"Europe/Madrid","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"스페인","pt-BR":"Espanha","pt":"Espanha","nl":"Spanje","hr":"Španjolska","fa":"اسپانیا","de":"Spanien","es":"España","fr":"Espagne","ja":"スペイン","it":"Spagna","zh-CN":"西班牙","tr":"İspanya","ru":"Испания","uk":"Іспанія","pl":"Hiszpania"}',
        40.00000000,
        -4.00000000,
        '🇪🇸',
        'U+1F1EA U+1F1F8',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q29'
    );

INSERT INTO
    public.countries
VALUES
    (
        208,
        'Sri Lanka',
        'LKA',
        '144',
        'LK',
        '94',
        'Colombo',
        'LKR',
        'Sri Lankan rupee',
        'Rs',
        '.lk',
        'śrī laṃkāva',
        'Asia',
        3,
        'Southern Asia',
        14,
        'Sri Lankan',
        '[{"zoneName":"Asia/Colombo","gmtOffset":19800,"gmtOffsetName":"UTC+05:30","abbreviation":"IST","tzName":"Indian Standard Time"}]',
        '{"ko":"스리랑카","pt-BR":"Sri Lanka","pt":"Sri Lanka","nl":"Sri Lanka","hr":"Šri Lanka","fa":"سری‌لانکا","de":"Sri Lanka","es":"Sri Lanka","fr":"Sri Lanka","ja":"スリランカ","it":"Sri Lanka","zh-CN":"斯里兰卡","tr":"Sri Lanka","ru":"Шри-Ланка","uk":"Шрі-Ланка","pl":"Sri Lanka"}',
        7.00000000,
        81.00000000,
        '🇱🇰',
        'U+1F1F1 U+1F1F0',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q854'
    );

INSERT INTO
    public.countries
VALUES
    (
        209,
        'Sudan',
        'SDN',
        '729',
        'SD',
        '249',
        'Khartoum',
        'SDG',
        'Sudanese pound',
        '.س.ج',
        '.sd',
        'السودان',
        'Africa',
        1,
        'Northern Africa',
        1,
        'Sudanese',
        '[{"zoneName":"Africa/Khartoum","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EAT","tzName":"Eastern African Time"}]',
        '{"ko":"수단","pt-BR":"Sudão","pt":"Sudão","nl":"Soedan","hr":"Sudan","fa":"سودان","de":"Sudan","es":"Sudán","fr":"Soudan","ja":"スーダン","it":"Sudan","zh-CN":"苏丹","tr":"Sudan","ru":"Судан","uk":"Судан","pl":"Sudan"}',
        15.00000000,
        30.00000000,
        '🇸🇩',
        'U+1F1F8 U+1F1E9',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q1049'
    );

INSERT INTO
    public.countries
VALUES
    (
        210,
        'Suriname',
        'SUR',
        '740',
        'SR',
        '597',
        'Paramaribo',
        'SRD',
        'Surinamese dollar',
        '$',
        '.sr',
        'Suriname',
        'Americas',
        2,
        'South America',
        8,
        'Surinamese',
        '[{"zoneName":"America/Paramaribo","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"SRT","tzName":"Suriname Time"}]',
        '{"ko":"수리남","pt-BR":"Suriname","pt":"Suriname","nl":"Suriname","hr":"Surinam","fa":"سورینام","de":"Suriname","es":"Surinam","fr":"Surinam","ja":"スリナム","it":"Suriname","zh-CN":"苏里南","tr":"Surinam","ru":"Суринам","uk":"Суринам","pl":"Surinam"}',
        4.00000000,
        -56.00000000,
        '🇸🇷',
        'U+1F1F8 U+1F1F7',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q730'
    );

INSERT INTO
    public.countries
VALUES
    (
        211,
        'Svalbard and Jan Mayen Islands',
        'SJM',
        '744',
        'SJ',
        '47',
        'Longyearbyen',
        'NOK',
        'Norwegian krone',
        'ko',
        '.sj',
        'Svalbard og Jan Mayen',
        'Europe',
        4,
        'Northern Europe',
        18,
        'Svalbard',
        '[{"zoneName":"Arctic/Longyearbyen","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"스발바르 얀마옌 제도","pt-BR":"Svalbard","pt":"Svalbard","nl":"Svalbard en Jan Mayen","hr":"Svalbard i Jan Mayen","fa":"سوالبارد و یان ماین","de":"Svalbard und Jan Mayen","es":"Islas Svalbard y Jan Mayen","fr":"Svalbard et Jan Mayen","ja":"スヴァールバル諸島およびヤンマイエン島","it":"Svalbard e Jan Mayen","zh-CN":"斯瓦尔巴和扬马延群岛","tr":"Svalbard Ve Jan Mayen","ru":"Шпицберген и острова Ян-Майен","uk":"Шпіцберген та острови Ян-Майєн","pl":"Wyspy Svalbard i Jan Mayen"}',
        78.00000000,
        20.00000000,
        '🇸🇯',
        'U+1F1F8 U+1F1EF',
        '2018-07-21 12:41:03',
        '2024-12-23 15:33:12',
        1,
        'Q842829'
    );

INSERT INTO
    public.countries
VALUES
    (
        212,
        'Eswatini',
        'SWZ',
        '748',
        'SZ',
        '268',
        'Mbabane',
        'SZL',
        'Lilangeni',
        'E',
        '.sz',
        'Swaziland',
        'Africa',
        1,
        'Southern Africa',
        5,
        'Swazi',
        '[{"zoneName":"Africa/Mbabane","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"SAST","tzName":"South African Standard Time"}]',
        '{"ko":"에스와티니","pt-BR":"Suazilândia","pt":"Suazilândia","nl":"Swaziland","hr":"Svazi","fa":"سوازیلند","de":"Swasiland","es":"Suazilandia","fr":"Swaziland","ja":"スワジランド","it":"Swaziland","zh-CN":"斯威士兰","tr":"Esvatini","ru":"Эсватини","uk":"Есватіні","pl":"Eswatini"}',
        -26.50000000,
        31.50000000,
        '🇸🇿',
        'U+1F1F8 U+1F1FF',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q1050'
    );

INSERT INTO
    public.countries
VALUES
    (
        213,
        'Sweden',
        'SWE',
        '752',
        'SE',
        '46',
        'Stockholm',
        'SEK',
        'Swedish krona',
        'ko',
        '.se',
        'Sverige',
        'Europe',
        4,
        'Northern Europe',
        18,
        'Swedish',
        '[{"zoneName":"Europe/Stockholm","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"스웨덴","pt-BR":"Suécia","pt":"Suécia","nl":"Zweden","hr":"Švedska","fa":"سوئد","de":"Schweden","es":"Suecia","fr":"Suède","ja":"スウェーデン","it":"Svezia","zh-CN":"瑞典","tr":"İsveç","ru":"Швеция","uk":"Швеція","pl":"Szwecja"}',
        62.00000000,
        15.00000000,
        '🇸🇪',
        'U+1F1F8 U+1F1EA',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q34'
    );

INSERT INTO
    public.countries
VALUES
    (
        214,
        'Switzerland',
        'CHE',
        '756',
        'CH',
        '41',
        'Bern',
        'CHF',
        'Swiss franc',
        'CHf',
        '.ch',
        'Schweiz',
        'Europe',
        4,
        'Western Europe',
        17,
        'Swiss',
        '[{"zoneName":"Europe/Zurich","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"스위스","pt-BR":"Suíça","pt":"Suíça","nl":"Zwitserland","hr":"Švicarska","fa":"سوئیس","de":"Schweiz","es":"Suiza","fr":"Suisse","ja":"スイス","it":"Svizzera","zh-CN":"瑞士","tr":"İsviçre","ru":"Швейцария","uk":"Швейцарія","pl":"Szwajcaria"}',
        47.00000000,
        8.00000000,
        '🇨🇭',
        'U+1F1E8 U+1F1ED',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q39'
    );

INSERT INTO
    public.countries
VALUES
    (
        215,
        'Syria',
        'SYR',
        '760',
        'SY',
        '963',
        'Damascus',
        'SYP',
        'Syrian pound',
        'LS',
        '.sy',
        'سوريا',
        'Asia',
        3,
        'Western Asia',
        11,
        'Syrian',
        '[{"zoneName":"Asia/Damascus","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"시리아","pt-BR":"Síria","pt":"Síria","nl":"Syrië","hr":"Sirija","fa":"سوریه","de":"Syrien","es":"Siria","fr":"Syrie","ja":"シリア・アラブ共和国","it":"Siria","zh-CN":"叙利亚","tr":"Suriye","ru":"Сирия","uk":"Сирія","pl":"Syria"}',
        35.00000000,
        38.00000000,
        '🇸🇾',
        'U+1F1F8 U+1F1FE',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q858'
    );

INSERT INTO
    public.countries
VALUES
    (
        216,
        'Taiwan',
        'TWN',
        '158',
        'TW',
        '886',
        'Taipei',
        'TWD',
        'New Taiwan dollar',
        '$',
        '.tw',
        '臺灣',
        'Asia',
        3,
        'Eastern Asia',
        12,
        'Chinese, Taiwanese',
        '[{"zoneName":"Asia/Taipei","gmtOffset":28800,"gmtOffsetName":"UTC+08:00","abbreviation":"CST","tzName":"China Standard Time"}]',
        '{"ko":"대만","pt-BR":"Taiwan","pt":"Taiwan","nl":"Taiwan","hr":"Tajvan","fa":"تایوان","de":"Taiwan","es":"Taiwán","fr":"Taïwan","ja":"台湾（中華民国）","it":"Taiwan","zh-CN":"中国台湾","tr":"Tayvan","ru":"Тайвань","uk":"Тайвань","pl":"Tajwan"}',
        23.50000000,
        121.00000000,
        '🇹🇼',
        'U+1F1F9 U+1F1FC',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q865'
    );

INSERT INTO
    public.countries
VALUES
    (
        217,
        'Tajikistan',
        'TJK',
        '762',
        'TJ',
        '992',
        'Dushanbe',
        'TJS',
        'Tajikistani somoni',
        'SM',
        '.tj',
        'Тоҷикистон',
        'Asia',
        3,
        'Central Asia',
        10,
        'Tajikistani',
        '[{"zoneName":"Asia/Dushanbe","gmtOffset":18000,"gmtOffsetName":"UTC+05:00","abbreviation":"TJT","tzName":"Tajikistan Time"}]',
        '{"ko":"타지키스탄","pt-BR":"Tajiquistão","pt":"Tajiquistão","nl":"Tadzjikistan","hr":"Tađikistan","fa":"تاجیکستان","de":"Tadschikistan","es":"Tayikistán","fr":"Tadjikistan","ja":"タジキスタン","it":"Tagikistan","zh-CN":"塔吉克斯坦","tr":"Tacikistan","ru":"Таджикистан","uk":"Таджикистан","pl":"Tadżykistan"}',
        39.00000000,
        71.00000000,
        '🇹🇯',
        'U+1F1F9 U+1F1EF',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q863'
    );

INSERT INTO
    public.countries
VALUES
    (
        218,
        'Tanzania',
        'TZA',
        '834',
        'TZ',
        '255',
        'Dodoma',
        'TZS',
        'Tanzanian shilling',
        'TSh',
        '.tz',
        'Tanzania',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Tanzanian',
        '[{"zoneName":"Africa/Dar_es_Salaam","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"EAT","tzName":"East Africa Time"}]',
        '{"ko":"탄자니아","pt-BR":"Tanzânia","pt":"Tanzânia","nl":"Tanzania","hr":"Tanzanija","fa":"تانزانیا","de":"Tansania","es":"Tanzania","fr":"Tanzanie","ja":"タンザニア","it":"Tanzania","zh-CN":"坦桑尼亚","tr":"Tanzanya","ru":"Танзания","uk":"Танзанія","pl":"Tanzania"}',
        -6.00000000,
        35.00000000,
        '🇹🇿',
        'U+1F1F9 U+1F1FF',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q924'
    );

INSERT INTO
    public.countries
VALUES
    (
        219,
        'Thailand',
        'THA',
        '764',
        'TH',
        '66',
        'Bangkok',
        'THB',
        'Thai baht',
        '฿',
        '.th',
        'ประเทศไทย',
        'Asia',
        3,
        'South-Eastern Asia',
        13,
        'Thai',
        '[{"zoneName":"Asia/Bangkok","gmtOffset":25200,"gmtOffsetName":"UTC+07:00","abbreviation":"ICT","tzName":"Indochina Time"}]',
        '{"ko":"태국","pt-BR":"Tailândia","pt":"Tailândia","nl":"Thailand","hr":"Tajland","fa":"تایلند","de":"Thailand","es":"Tailandia","fr":"Thaïlande","ja":"タイ","it":"Tailandia","zh-CN":"泰国","tr":"Tayland","ru":"Таиланд","uk":"Таїланд","pl":"Tajlandia"}',
        15.00000000,
        100.00000000,
        '🇹🇭',
        'U+1F1F9 U+1F1ED',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q869'
    );

INSERT INTO
    public.countries
VALUES
    (
        220,
        'Togo',
        'TGO',
        '768',
        'TG',
        '228',
        'Lome',
        'XOF',
        'West African CFA franc',
        'CFA',
        '.tg',
        'Togo',
        'Africa',
        1,
        'Western Africa',
        3,
        'Togolese',
        '[{"zoneName":"Africa/Lome","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"토고","pt-BR":"Togo","pt":"Togo","nl":"Togo","hr":"Togo","fa":"توگو","de":"Togo","es":"Togo","fr":"Togo","ja":"トーゴ","it":"Togo","zh-CN":"多哥","tr":"Togo","ru":"Того","uk":"Того","pl":"Togo"}',
        8.00000000,
        1.16666666,
        '🇹🇬',
        'U+1F1F9 U+1F1EC',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q945'
    );

INSERT INTO
    public.countries
VALUES
    (
        221,
        'Tokelau',
        'TKL',
        '772',
        'TK',
        '690',
        '',
        'NZD',
        'New Zealand dollar',
        '$',
        '.tk',
        'Tokelau',
        'Oceania',
        5,
        'Polynesia',
        22,
        'Tokelauan',
        '[{"zoneName":"Pacific/Fakaofo","gmtOffset":46800,"gmtOffsetName":"UTC+13:00","abbreviation":"TKT","tzName":"Tokelau Time"}]',
        '{"ko":"토켈라우","pt-BR":"Tokelau","pt":"Toquelau","nl":"Tokelau","hr":"Tokelau","fa":"توکلائو","de":"Tokelau","es":"Islas Tokelau","fr":"Tokelau","ja":"トケラウ","it":"Isole Tokelau","zh-CN":"托克劳","tr":"Tokelau","ru":"Токелау","uk":"Токелау","pl":"Tokelau"}',
        -9.00000000,
        -172.00000000,
        '🇹🇰',
        'U+1F1F9 U+1F1F0',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q36823'
    );

INSERT INTO
    public.countries
VALUES
    (
        222,
        'Tonga',
        'TON',
        '776',
        'TO',
        '676',
        'Nuku''alofa',
        'TOP',
        'Tongan paʻanga',
        '$',
        '.to',
        'Tonga',
        'Oceania',
        5,
        'Polynesia',
        22,
        'Tongan',
        '[{"zoneName":"Pacific/Tongatapu","gmtOffset":46800,"gmtOffsetName":"UTC+13:00","abbreviation":"TOT","tzName":"Tonga Time"}]',
        '{"ko":"통가","pt-BR":"Tonga","pt":"Tonga","nl":"Tonga","hr":"Tonga","fa":"تونگا","de":"Tonga","es":"Tonga","fr":"Tonga","ja":"トンガ","it":"Tonga","zh-CN":"汤加","tr":"Tonga","ru":"Тонга","uk":"Тонга","pl":"Tonga"}',
        -20.00000000,
        -175.00000000,
        '🇹🇴',
        'U+1F1F9 U+1F1F4',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q678'
    );

INSERT INTO
    public.countries
VALUES
    (
        223,
        'Trinidad and Tobago',
        'TTO',
        '780',
        'TT',
        '1',
        'Port of Spain',
        'TTD',
        'Trinidad and Tobago dollar',
        '$',
        '.tt',
        'Trinidad and Tobago',
        'Americas',
        2,
        'Caribbean',
        7,
        'Trinidadian or Tobagonian',
        '[{"zoneName":"America/Port_of_Spain","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"트리니다드 토바고","pt-BR":"Trinidad e Tobago","pt":"Trindade e Tobago","nl":"Trinidad en Tobago","hr":"Trinidad i Tobago","fa":"ترینیداد و توباگو","de":"Trinidad und Tobago","es":"Trinidad y Tobago","fr":"Trinité et Tobago","ja":"トリニダード・トバゴ","it":"Trinidad e Tobago","zh-CN":"特立尼达和多巴哥","tr":"Trinidad Ve Tobago","ru":"Тринидад и Тобаго","uk":"Тринідад і Тобаго","pl":"Trynidad i Tobago"}',
        11.00000000,
        -61.00000000,
        '🇹🇹',
        'U+1F1F9 U+1F1F9',
        '2018-07-21 12:41:03',
        '2024-09-05 16:47:03',
        1,
        'Q754'
    );

INSERT INTO
    public.countries
VALUES
    (
        224,
        'Tunisia',
        'TUN',
        '788',
        'TN',
        '216',
        'Tunis',
        'TND',
        'Tunisian dinar',
        'ت.د',
        '.tn',
        'تونس',
        'Africa',
        1,
        'Northern Africa',
        1,
        'Tunisian',
        '[{"zoneName":"Africa/Tunis","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"튀니지","pt-BR":"Tunísia","pt":"Tunísia","nl":"Tunesië","hr":"Tunis","fa":"تونس","de":"Tunesien","es":"Túnez","fr":"Tunisie","ja":"チュニジア","it":"Tunisia","zh-CN":"突尼斯","tr":"Tunus","ru":"Тунис","uk":"Туніс","pl":"Tunezja"}',
        34.00000000,
        9.00000000,
        '🇹🇳',
        'U+1F1F9 U+1F1F3',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q948'
    );

INSERT INTO
    public.countries
VALUES
    (
        225,
        'Turkey',
        'TUR',
        '792',
        'TR',
        '90',
        'Ankara',
        'TRY',
        'Turkish lira',
        '₺',
        '.tr',
        'Türkiye',
        'Asia',
        3,
        'Western Asia',
        11,
        'Turkish',
        '[{"zoneName":"Europe/Istanbul","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"터키","pt-BR":"Turquia","pt":"Turquia","nl":"Turkije","hr":"Turska","fa":"ترکیه","de":"Türkei","es":"Turquía","fr":"Turquie","ja":"トルコ","it":"Turchia","zh-CN":"土耳其","tr":"Türkiye","ru":"Турция","uk":"Туреччина","pl":"Turcja"}',
        39.00000000,
        35.00000000,
        '🇹🇷',
        'U+1F1F9 U+1F1F7',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q43'
    );

INSERT INTO
    public.countries
VALUES
    (
        226,
        'Turkmenistan',
        'TKM',
        '795',
        'TM',
        '993',
        'Ashgabat',
        'TMT',
        'Turkmenistan manat',
        'T',
        '.tm',
        'Türkmenistan',
        'Asia',
        3,
        'Central Asia',
        10,
        'Turkmen',
        '[{"zoneName":"Asia/Ashgabat","gmtOffset":18000,"gmtOffsetName":"UTC+05:00","abbreviation":"TMT","tzName":"Turkmenistan Time"}]',
        '{"ko":"투르크메니스탄","pt-BR":"Turcomenistão","pt":"Turquemenistão","nl":"Turkmenistan","hr":"Turkmenistan","fa":"ترکمنستان","de":"Turkmenistan","es":"Turkmenistán","fr":"Turkménistan","ja":"トルクメニスタン","it":"Turkmenistan","zh-CN":"土库曼斯坦","tr":"Türkmenistan","ru":"Туркменистан","uk":"Туркменістан","pl":"Turkmenistan"}',
        40.00000000,
        60.00000000,
        '🇹🇲',
        'U+1F1F9 U+1F1F2',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q874'
    );

INSERT INTO
    public.countries
VALUES
    (
        227,
        'Turks and Caicos Islands',
        'TCA',
        '796',
        'TC',
        '1',
        'Cockburn Town',
        'USD',
        'United States dollar',
        '$',
        '.tc',
        'Turks and Caicos Islands',
        'Americas',
        2,
        'Caribbean',
        7,
        'Turks and Caicos Island',
        '[{"zoneName":"America/Grand_Turk","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"}]',
        '{"ko":"터크스 케이커스 제도","pt-BR":"Ilhas Turcas e Caicos","pt":"Ilhas Turcas e Caicos","nl":"Turks- en Caicoseilanden","hr":"Otoci Turks i Caicos","fa":"جزایر تورکس و کایکوس","de":"Turks- und Caicosinseln","es":"Islas Turks y Caicos","fr":"Îles Turques-et-Caïques","ja":"タークス・カイコス諸島","it":"Isole Turks e Caicos","zh-CN":"特克斯和凯科斯群岛","tr":"Turks Ve Caicos Adalari","ru":"Острова Теркс и Кайкос","uk":"Острови Теркс і Кайкос","pl":"Wyspy Turks i Caicos"}',
        21.75000000,
        -71.58333333,
        '🇹🇨',
        'U+1F1F9 U+1F1E8',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q18221'
    );

INSERT INTO
    public.countries
VALUES
    (
        228,
        'Tuvalu',
        'TUV',
        '798',
        'TV',
        '688',
        'Funafuti',
        'AUD',
        'Australian dollar',
        '$',
        '.tv',
        'Tuvalu',
        'Oceania',
        5,
        'Polynesia',
        22,
        'Tuvaluan',
        '[{"zoneName":"Pacific/Funafuti","gmtOffset":43200,"gmtOffsetName":"UTC+12:00","abbreviation":"TVT","tzName":"Tuvalu Time"}]',
        '{"ko":"투발루","pt-BR":"Tuvalu","pt":"Tuvalu","nl":"Tuvalu","hr":"Tuvalu","fa":"تووالو","de":"Tuvalu","es":"Tuvalu","fr":"Tuvalu","ja":"ツバル","it":"Tuvalu","zh-CN":"图瓦卢","tr":"Tuvalu","ru":"Тувалу","uk":"Тувалу","pl":"Tuvalu"}',
        -8.00000000,
        178.00000000,
        '🇹🇻',
        'U+1F1F9 U+1F1FB',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q672'
    );

INSERT INTO
    public.countries
VALUES
    (
        229,
        'Uganda',
        'UGA',
        '800',
        'UG',
        '256',
        'Kampala',
        'UGX',
        'Ugandan shilling',
        'USh',
        '.ug',
        'Uganda',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Ugandan',
        '[{"zoneName":"Africa/Kampala","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"EAT","tzName":"East Africa Time"}]',
        '{"ko":"우간다","pt-BR":"Uganda","pt":"Uganda","nl":"Oeganda","hr":"Uganda","fa":"اوگاندا","de":"Uganda","es":"Uganda","fr":"Uganda","ja":"ウガンダ","it":"Uganda","zh-CN":"乌干达","tr":"Uganda","ru":"Уганда","uk":"Уганда","pl":"Uganda"}',
        1.00000000,
        32.00000000,
        '🇺🇬',
        'U+1F1FA U+1F1EC',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q1036'
    );

INSERT INTO
    public.countries
VALUES
    (
        230,
        'Ukraine',
        'UKR',
        '804',
        'UA',
        '380',
        'Kyiv',
        'UAH',
        'Ukrainian hryvnia',
        '₴',
        '.ua',
        'Україна',
        'Europe',
        4,
        'Eastern Europe',
        15,
        'Ukrainian',
        '[{"zoneName":"Europe/Kiev","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"},{"zoneName":"Europe/Simferopol","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"MSK","tzName":"Moscow Time"},{"zoneName":"Europe/Uzhgorod","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"},{"zoneName":"Europe/Zaporozhye","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"EET","tzName":"Eastern European Time"}]',
        '{"ko":"우크라이나","pt-BR":"Ucrânia","pt":"Ucrânia","nl":"Oekraïne","hr":"Ukrajina","fa":"وکراین","de":"Ukraine","es":"Ucrania","fr":"Ukraine","ja":"ウクライナ","it":"Ucraina","zh-CN":"乌克兰","tr":"Ukrayna","ru":"Украина","uk":"Україна","pl":"Ukraina"}',
        49.00000000,
        32.00000000,
        '🇺🇦',
        'U+1F1FA U+1F1E6',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q212'
    );

INSERT INTO
    public.countries
VALUES
    (
        231,
        'United Arab Emirates',
        'ARE',
        '784',
        'AE',
        '971',
        'Abu Dhabi',
        'AED',
        'United Arab Emirates dirham',
        'إ.د',
        '.ae',
        'دولة الإمارات العربية المتحدة',
        'Asia',
        3,
        'Western Asia',
        11,
        'Emirati, Emirian, Emiri',
        '[{"zoneName":"Asia/Dubai","gmtOffset":14400,"gmtOffsetName":"UTC+04:00","abbreviation":"GST","tzName":"Gulf Standard Time"}]',
        '{"ko":"아랍에미리트","pt-BR":"Emirados árabes Unidos","pt":"Emirados árabes Unidos","nl":"Verenigde Arabische Emiraten","hr":"Ujedinjeni Arapski Emirati","fa":"امارات متحده عربی","de":"Vereinigte Arabische Emirate","es":"Emiratos Árabes Unidos","fr":"Émirats arabes unis","ja":"アラブ首長国連邦","it":"Emirati Arabi Uniti","zh-CN":"阿拉伯联合酋长国","tr":"Birleşik Arap Emirlikleri","ru":"Объединенные Арабские Эмираты","uk":"Об''єднані Арабські Емірати","pl":"Zjednoczone Emiraty Arabskie"}',
        24.00000000,
        54.00000000,
        '🇦🇪',
        'U+1F1E6 U+1F1EA',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q878'
    );

INSERT INTO
    public.countries
VALUES
    (
        232,
        'United Kingdom',
        'GBR',
        '826',
        'GB',
        '44',
        'London',
        'GBP',
        'British pound',
        '£',
        '.uk',
        'United Kingdom',
        'Europe',
        4,
        'Northern Europe',
        18,
        'British, UK',
        '[{"zoneName":"Europe/London","gmtOffset":0,"gmtOffsetName":"UTC±00","abbreviation":"GMT","tzName":"Greenwich Mean Time"}]',
        '{"ko":"영국","pt-BR":"Reino Unido","pt":"Reino Unido","nl":"Verenigd Koninkrijk","hr":"Ujedinjeno Kraljevstvo","fa":"بریتانیای کبیر و ایرلند شمالی","de":"Vereinigtes Königreich","es":"Reino Unido","fr":"Royaume-Uni","ja":"イギリス","it":"Regno Unito","zh-CN":"英国","tr":"Birleşik Krallik","ru":"Великобритания","uk":"Сполучене Королівство","pl":"Wielka Brytania"}',
        54.00000000,
        -2.00000000,
        '🇬🇧',
        'U+1F1EC U+1F1E7',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q145'
    );

INSERT INTO
    public.countries
VALUES
    (
        233,
        'United States',
        'USA',
        '840',
        'US',
        '1',
        'Washington',
        'USD',
        'United States dollar',
        '$',
        '.us',
        'United States',
        'Americas',
        2,
        'Northern America',
        6,
        'American',
        '[{"zoneName":"America/Adak","gmtOffset":-36000,"gmtOffsetName":"UTC-10:00","abbreviation":"HST","tzName":"Hawaii–Aleutian Standard Time"},{"zoneName":"America/Anchorage","gmtOffset":-32400,"gmtOffsetName":"UTC-09:00","abbreviation":"AKST","tzName":"Alaska Standard Time"},{"zoneName":"America/Boise","gmtOffset":-25200,"gmtOffsetName":"UTC-07:00","abbreviation":"MST","tzName":"Mountain Standard Time (North America"},{"zoneName":"America/Chicago","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/Denver","gmtOffset":-25200,"gmtOffsetName":"UTC-07:00","abbreviation":"MST","tzName":"Mountain Standard Time (North America"},{"zoneName":"America/Detroit","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"},{"zoneName":"America/Indiana/Indianapolis","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"},{"zoneName":"America/Indiana/Knox","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/Indiana/Marengo","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"},{"zoneName":"America/Indiana/Petersburg","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"},{"zoneName":"America/Indiana/Tell_City","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/Indiana/Vevay","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"},{"zoneName":"America/Indiana/Vincennes","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"},{"zoneName":"America/Indiana/Winamac","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"},{"zoneName":"America/Juneau","gmtOffset":-32400,"gmtOffsetName":"UTC-09:00","abbreviation":"AKST","tzName":"Alaska Standard Time"},{"zoneName":"America/Kentucky/Louisville","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"},{"zoneName":"America/Kentucky/Monticello","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"},{"zoneName":"America/Los_Angeles","gmtOffset":-28800,"gmtOffsetName":"UTC-08:00","abbreviation":"PST","tzName":"Pacific Standard Time (North America"},{"zoneName":"America/Menominee","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/Metlakatla","gmtOffset":-32400,"gmtOffsetName":"UTC-09:00","abbreviation":"AKST","tzName":"Alaska Standard Time"},{"zoneName":"America/New_York","gmtOffset":-18000,"gmtOffsetName":"UTC-05:00","abbreviation":"EST","tzName":"Eastern Standard Time (North America"},{"zoneName":"America/Nome","gmtOffset":-32400,"gmtOffsetName":"UTC-09:00","abbreviation":"AKST","tzName":"Alaska Standard Time"},{"zoneName":"America/North_Dakota/Beulah","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/North_Dakota/Center","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/North_Dakota/New_Salem","gmtOffset":-21600,"gmtOffsetName":"UTC-06:00","abbreviation":"CST","tzName":"Central Standard Time (North America"},{"zoneName":"America/Phoenix","gmtOffset":-25200,"gmtOffsetName":"UTC-07:00","abbreviation":"MST","tzName":"Mountain Standard Time (North America"},{"zoneName":"America/Sitka","gmtOffset":-32400,"gmtOffsetName":"UTC-09:00","abbreviation":"AKST","tzName":"Alaska Standard Time"},{"zoneName":"America/Yakutat","gmtOffset":-32400,"gmtOffsetName":"UTC-09:00","abbreviation":"AKST","tzName":"Alaska Standard Time"},{"zoneName":"Pacific/Honolulu","gmtOffset":-36000,"gmtOffsetName":"UTC-10:00","abbreviation":"HST","tzName":"Hawaii–Aleutian Standard Time"}]',
        '{"ko":"미국","pt-BR":"Estados Unidos","pt":"Estados Unidos","nl":"Verenigde Staten","hr":"Sjedinjene Američke Države","fa":"ایالات متحده آمریکا","de":"Vereinigte Staaten von Amerika","es":"Estados Unidos","fr":"États-Unis","ja":"アメリカ合衆国","it":"Stati Uniti D''America","zh-CN":"美国","tr":"Amerika","ru":"Соединенные Штаты","uk":"Сполучені Штати","pl":"Stany Zjednoczone"}',
        38.00000000,
        -97.00000000,
        '🇺🇸',
        'U+1F1FA U+1F1F8',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q30'
    );

INSERT INTO
    public.countries
VALUES
    (
        234,
        'United States Minor Outlying Islands',
        'UMI',
        '581',
        'UM',
        '1',
        '',
        'USD',
        'United States dollar',
        '$',
        '.us',
        'United States Minor Outlying Islands',
        'Americas',
        2,
        'Northern America',
        6,
        'American',
        '[{"zoneName":"Pacific/Midway","gmtOffset":-39600,"gmtOffsetName":"UTC-11:00","abbreviation":"SST","tzName":"Samoa Standard Time"},{"zoneName":"Pacific/Wake","gmtOffset":43200,"gmtOffsetName":"UTC+12:00","abbreviation":"WAKT","tzName":"Wake Island Time"}]',
        '{"ko":"미국령 군소 제도","pt-BR":"Ilhas Menores Distantes dos Estados Unidos","pt":"Ilhas Menores Distantes dos Estados Unidos","nl":"Kleine afgelegen eilanden van de Verenigde Staten","hr":"Mali udaljeni otoci SAD-a","fa":"جزایر کوچک حاشیه‌ای ایالات متحده آمریکا","de":"Kleinere Inselbesitzungen der Vereinigten Staaten","es":"Islas Ultramarinas Menores de Estados Unidos","fr":"Îles mineures éloignées des États-Unis","ja":"合衆国領有小離島","it":"Isole minori esterne degli Stati Uniti d''America","zh-CN":"美国本土外小岛屿","tr":"Abd Küçük Harici Adalari","ru":"Малые отдаленные острова Соединенных Штатов","uk":"Малі віддалені острови Сполучених Штатів","pl":"Mniejsze Wyspy Zewnętrzne Stanów Zjednoczonych"}',
        0.00000000,
        0.00000000,
        '🇺🇲',
        'U+1F1FA U+1F1F2',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q16645'
    );

INSERT INTO
    public.countries
VALUES
    (
        235,
        'Uruguay',
        'URY',
        '858',
        'UY',
        '598',
        'Montevideo',
        'UYU',
        'Uruguayan peso',
        '$',
        '.uy',
        'Uruguay',
        'Americas',
        2,
        'South America',
        8,
        'Uruguayan',
        '[{"zoneName":"America/Montevideo","gmtOffset":-10800,"gmtOffsetName":"UTC-03:00","abbreviation":"UYT","tzName":"Uruguay Standard Time"}]',
        '{"ko":"우루과이","pt-BR":"Uruguai","pt":"Uruguai","nl":"Uruguay","hr":"Urugvaj","fa":"اروگوئه","de":"Uruguay","es":"Uruguay","fr":"Uruguay","ja":"ウルグアイ","it":"Uruguay","zh-CN":"乌拉圭","tr":"Uruguay","ru":"Уругвай","uk":"Уругвай","pl":"Urugwaj"}',
        -33.00000000,
        -56.00000000,
        '🇺🇾',
        'U+1F1FA U+1F1FE',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q77'
    );

INSERT INTO
    public.countries
VALUES
    (
        236,
        'Uzbekistan',
        'UZB',
        '860',
        'UZ',
        '998',
        'Tashkent',
        'UZS',
        'Uzbekistani soʻm',
        'лв',
        '.uz',
        'O‘zbekiston',
        'Asia',
        3,
        'Central Asia',
        10,
        'Uzbekistani, Uzbek',
        '[{"zoneName":"Asia/Samarkand","gmtOffset":18000,"gmtOffsetName":"UTC+05:00","abbreviation":"UZT","tzName":"Uzbekistan Time"},{"zoneName":"Asia/Tashkent","gmtOffset":18000,"gmtOffsetName":"UTC+05:00","abbreviation":"UZT","tzName":"Uzbekistan Time"}]',
        '{"ko":"우즈베키스탄","pt-BR":"Uzbequistão","pt":"Usbequistão","nl":"Oezbekistan","hr":"Uzbekistan","fa":"ازبکستان","de":"Usbekistan","es":"Uzbekistán","fr":"Ouzbékistan","ja":"ウズベキスタン","it":"Uzbekistan","zh-CN":"乌兹别克斯坦","tr":"Özbekistan","ru":"Узбекистан","uk":"Узбекистан","pl":"Uzbekistan"}',
        41.00000000,
        64.00000000,
        '🇺🇿',
        'U+1F1FA U+1F1FF',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q265'
    );

INSERT INTO
    public.countries
VALUES
    (
        237,
        'Vanuatu',
        'VUT',
        '548',
        'VU',
        '678',
        'Port Vila',
        'VUV',
        'Vanuatu vatu',
        'VT',
        '.vu',
        'Vanuatu',
        'Oceania',
        5,
        'Melanesia',
        20,
        'Ni-Vanuatu, Vanuatuan',
        '[{"zoneName":"Pacific/Efate","gmtOffset":39600,"gmtOffsetName":"UTC+11:00","abbreviation":"VUT","tzName":"Vanuatu Time"}]',
        '{"ko":"바누아투","pt-BR":"Vanuatu","pt":"Vanuatu","nl":"Vanuatu","hr":"Vanuatu","fa":"وانواتو","de":"Vanuatu","es":"Vanuatu","fr":"Vanuatu","ja":"バヌアツ","it":"Vanuatu","zh-CN":"瓦努阿图","tr":"Vanuatu","ru":"Вануату","uk":"Вануату","pl":"Vanuatu"}',
        -16.00000000,
        167.00000000,
        '🇻🇺',
        'U+1F1FB U+1F1FA',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q686'
    );

INSERT INTO
    public.countries
VALUES
    (
        238,
        'Vatican City State (Holy See)',
        'VAT',
        '336',
        'VA',
        '379',
        'Vatican City',
        'EUR',
        'Euro',
        '€',
        '.va',
        'Vaticano',
        'Europe',
        4,
        'Southern Europe',
        16,
        'Vatican',
        '[{"zoneName":"Europe/Vatican","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"CET","tzName":"Central European Time"}]',
        '{"ko":"바티칸 시국","pt-BR":"Vaticano","pt":"Vaticano","nl":"Heilige Stoel","hr":"Sveta Stolica","fa":"سریر مقدس","de":"Heiliger Stuhl","es":"Santa Sede","fr":"voir Saint","ja":"聖座","it":"Santa Sede","zh-CN":"梵蒂冈","tr":"Vatikan","ru":"Город-государство Ватикан (Святой Престол)","uk":"Держава-місто Ватикан (Святий Престол)","pl":"Państwo Watykańskie (Stolica Apostolska)"}',
        41.90000000,
        12.45000000,
        '🇻🇦',
        'U+1F1FB U+1F1E6',
        '2018-07-21 12:41:03',
        '2023-08-11 21:15:55',
        1,
        'Q237'
    );

INSERT INTO
    public.countries
VALUES
    (
        239,
        'Venezuela',
        'VEN',
        '862',
        'VE',
        '58',
        'Caracas',
        'VES',
        'Bolívar',
        'Bs',
        '.ve',
        'Venezuela',
        'Americas',
        2,
        'South America',
        8,
        'Venezuelan',
        '[{"zoneName":"America/Caracas","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"VET","tzName":"Venezuelan Standard Time"}]',
        '{"ko":"베네수엘라","pt-BR":"Venezuela","pt":"Venezuela","nl":"Venezuela","hr":"Venezuela","fa":"ونزوئلا","de":"Venezuela","es":"Venezuela","fr":"Venezuela","ja":"ベネズエラ・ボリバル共和国","it":"Venezuela","zh-CN":"委内瑞拉","tr":"Venezuela","ru":"Венесуэла","uk":"Венесуела","pl":"Wenezuela"}',
        8.00000000,
        -66.00000000,
        '🇻🇪',
        'U+1F1FB U+1F1EA',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q717'
    );

INSERT INTO
    public.countries
VALUES
    (
        240,
        'Vietnam',
        'VNM',
        '704',
        'VN',
        '84',
        'Hanoi',
        'VND',
        'Vietnamese đồng',
        '₫',
        '.vn',
        'Việt Nam',
        'Asia',
        3,
        'South-Eastern Asia',
        13,
        'Vietnamese',
        '[{"zoneName":"Asia/Ho_Chi_Minh","gmtOffset":25200,"gmtOffsetName":"UTC+07:00","abbreviation":"ICT","tzName":"Indochina Time"}]',
        '{"ko":"베트남","pt-BR":"Vietnã","pt":"Vietname","nl":"Vietnam","hr":"Vijetnam","fa":"ویتنام","de":"Vietnam","es":"Vietnam","fr":"Viêt Nam","ja":"ベトナム","it":"Vietnam","zh-CN":"越南","tr":"Vietnam","ru":"Вьетнам","uk":"В''єтнам","pl":"Wietnam"}',
        16.16666666,
        107.83333333,
        '🇻🇳',
        'U+1F1FB U+1F1F3',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q881'
    );

INSERT INTO
    public.countries
VALUES
    (
        242,
        'Virgin Islands (US)',
        'VIR',
        '850',
        'VI',
        '1',
        'Charlotte Amalie',
        'USD',
        'United States dollar',
        '$',
        '.vi',
        'United States Virgin Islands',
        'Americas',
        2,
        'Caribbean',
        7,
        'U.S. Virgin Island',
        '[{"zoneName":"America/St_Thomas","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"미국령 버진아일랜드","pt-BR":"Ilhas Virgens Americanas","pt":"Ilhas Virgens Americanas","nl":"Verenigde Staten Maagdeneilanden","fa":"جزایر ویرجین آمریکا","de":"Amerikanische Jungferninseln","es":"Islas Vírgenes de los Estados Unidos","fr":"Îles Vierges des États-Unis","ja":"アメリカ領ヴァージン諸島","it":"Isole Vergini americane","zh-CN":"维尔京群岛（美国）","tr":"Abd Virjin Adalari","ru":"Виргинские острова (США)","uk":"Віргінські острови (США)","pl":"Wyspy Dziewicze (USA)"}',
        18.34000000,
        -64.93000000,
        '🇻🇮',
        'U+1F1FB U+1F1EE',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q11703'
    );

INSERT INTO
    public.countries
VALUES
    (
        243,
        'Wallis and Futuna Islands',
        'WLF',
        '876',
        'WF',
        '681',
        'Mata Utu',
        'XPF',
        'CFP franc',
        '₣',
        '.wf',
        'Wallis et Futuna',
        'Oceania',
        5,
        'Polynesia',
        22,
        'Wallis and Futuna, Wallisian or Futunan',
        '[{"zoneName":"Pacific/Wallis","gmtOffset":43200,"gmtOffsetName":"UTC+12:00","abbreviation":"WFT","tzName":"Wallis & Futuna Time"}]',
        '{"ko":"왈리스 푸투나","pt-BR":"Wallis e Futuna","pt":"Wallis e Futuna","nl":"Wallis en Futuna","hr":"Wallis i Fortuna","fa":"والیس و فوتونا","de":"Wallis und Futuna","es":"Wallis y Futuna","fr":"Wallis-et-Futuna","ja":"ウォリス・フツナ","it":"Wallis e Futuna","zh-CN":"瓦利斯群岛和富图纳群岛","tr":"Wallis Ve Futuna","ru":"Острова Уоллис и Футуна","uk":"Острови Уолліс і Футуна","pl":"Wyspy Wallis i Futuna"}',
        -13.30000000,
        -176.20000000,
        '🇼🇫',
        'U+1F1FC U+1F1EB',
        '2018-07-21 12:41:03',
        '2024-12-19 21:04:08',
        1,
        'Q35555'
    );

INSERT INTO
    public.countries
VALUES
    (
        244,
        'Western Sahara',
        'ESH',
        '732',
        'EH',
        '212',
        'El-Aaiun',
        'MAD',
        'Moroccan dirham',
        'MAD',
        '.eh',
        'الصحراء الغربية',
        'Africa',
        1,
        'Northern Africa',
        1,
        'Sahrawi, Sahrawian, Sahraouian',
        '[{"zoneName":"Africa/El_Aaiun","gmtOffset":3600,"gmtOffsetName":"UTC+01:00","abbreviation":"WEST","tzName":"Western European Summer Time"}]',
        '{"ko":"서사하라","pt-BR":"Saara Ocidental","pt":"Saara Ocidental","nl":"Westelijke Sahara","hr":"Zapadna Sahara","fa":"جمهوری دموکراتیک عربی صحرا","de":"Westsahara","es":"Sahara Occidental","fr":"Sahara Occidental","ja":"西サハラ","it":"Sahara Occidentale","zh-CN":"西撒哈拉","tr":"Bati Sahra","ru":"Западная Сахара","uk":"Західна Сахара","pl":"Sahara Zachodnia"}',
        24.50000000,
        -13.00000000,
        '🇪🇭',
        'U+1F1EA U+1F1ED',
        '2018-07-21 12:41:03',
        '2024-12-23 15:33:12',
        1,
        'Q6250'
    );

INSERT INTO
    public.countries
VALUES
    (
        245,
        'Yemen',
        'YEM',
        '887',
        'YE',
        '967',
        'Sanaa',
        'YER',
        'Yemeni rial',
        '﷼',
        '.ye',
        'اليَمَن',
        'Asia',
        3,
        'Western Asia',
        11,
        'Yemeni',
        '[{"zoneName":"Asia/Aden","gmtOffset":10800,"gmtOffsetName":"UTC+03:00","abbreviation":"AST","tzName":"Arabia Standard Time"}]',
        '{"ko":"예멘","pt-BR":"Iêmen","pt":"Iémen","nl":"Jemen","hr":"Jemen","fa":"یمن","de":"Jemen","es":"Yemen","fr":"Yémen","ja":"イエメン","it":"Yemen","zh-CN":"也门","tr":"Yemen","ru":"Йемен","uk":"Ємен","pl":"Jemen"}',
        15.00000000,
        48.00000000,
        '🇾🇪',
        'U+1F1FE U+1F1EA',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q805'
    );

INSERT INTO
    public.countries
VALUES
    (
        246,
        'Zambia',
        'ZMB',
        '894',
        'ZM',
        '260',
        'Lusaka',
        'ZMW',
        'Zambian kwacha',
        'ZK',
        '.zm',
        'Zambia',
        'Africa',
        1,
        'Southern Africa',
        5,
        'Zambian',
        '[{"zoneName":"Africa/Lusaka","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"CAT","tzName":"Central Africa Time"}]',
        '{"ko":"잠비아","pt-BR":"Zâmbia","pt":"Zâmbia","nl":"Zambia","hr":"Zambija","fa":"زامبیا","de":"Sambia","es":"Zambia","fr":"Zambie","ja":"ザンビア","it":"Zambia","zh-CN":"赞比亚","tr":"Zambiya","ru":"Замбия","uk":"Замбія","pl":"Zambia"}',
        -15.00000000,
        30.00000000,
        '🇿🇲',
        'U+1F1FF U+1F1F2',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q953'
    );

INSERT INTO
    public.countries
VALUES
    (
        247,
        'Zimbabwe',
        'ZWE',
        '716',
        'ZW',
        '263',
        'Harare',
        'ZWL',
        'Zimbabwe Dollar',
        '$',
        '.zw',
        'Zimbabwe',
        'Africa',
        1,
        'Eastern Africa',
        4,
        'Zimbabwean',
        '[{"zoneName":"Africa/Harare","gmtOffset":7200,"gmtOffsetName":"UTC+02:00","abbreviation":"CAT","tzName":"Central Africa Time"}]',
        '{"ko":"짐바브웨","pt-BR":"Zimbabwe","pt":"Zimbabué","nl":"Zimbabwe","hr":"Zimbabve","fa":"زیمباوه","de":"Simbabwe","es":"Zimbabue","fr":"Zimbabwe","ja":"ジンバブエ","it":"Zimbabwe","zh-CN":"津巴布韦","tr":"Zimbabve","ru":"Зимбабве","uk":"Зімбабве","pl":"Zimbabwe"}',
        -20.00000000,
        30.00000000,
        '🇿🇼',
        'U+1F1FF U+1F1FC',
        '2018-07-21 12:41:03',
        '2023-08-10 00:53:19',
        1,
        'Q954'
    );

INSERT INTO
    public.countries
VALUES
    (
        249,
        'Curaçao',
        'CUW',
        '531',
        'CW',
        '599',
        'Willemstad',
        'ANG',
        'Netherlands Antillean guilder',
        'ƒ',
        '.cw',
        'Curaçao',
        'Americas',
        2,
        'Caribbean',
        7,
        'Curacaoan',
        '[{"zoneName":"America/Curacao","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"퀴라소","pt-BR":"Curaçao","pt":"Curaçao","nl":"Curaçao","fa":"کوراسائو","de":"Curaçao","fr":"Curaçao","it":"Curaçao","zh-CN":"库拉索","tr":"Curaçao","ru":"Кюрасао","uk":"Кюрасао","pl":"Curaçao"}',
        12.11666700,
        -68.93333300,
        '🇨🇼',
        'U+1F1E8 U+1F1FC',
        '2020-10-26 07:24:20',
        '2023-08-11 21:15:55',
        1,
        'Q25279'
    );

INSERT INTO
    public.countries
VALUES
    (
        250,
        'Sint Maarten (Dutch part)',
        'SXM',
        '534',
        'SX',
        '1721',
        'Philipsburg',
        'ANG',
        'Netherlands Antillean guilder',
        'ƒ',
        '.sx',
        'Sint Maarten',
        'Americas',
        2,
        'Caribbean',
        7,
        'Sint Maarten',
        '[{"zoneName":"America/Anguilla","gmtOffset":-14400,"gmtOffsetName":"UTC-04:00","abbreviation":"AST","tzName":"Atlantic Standard Time"}]',
        '{"ko":"신트마르턴","pt-BR":"Sint Maarten","pt":"São Martinho","nl":"Sint Maarten","fa":"سینت مارتن","de":"Sint Maarten (niederl. Teil)","fr":"Saint Martin (partie néerlandaise)","it":"Saint Martin (parte olandese)","zh-CN":"圣马丁岛（荷兰部分）","tr":"Sint Maarten","ru":"Синт-Мартен (голландская часть)","uk":"Сінт-Мартен (голландська частина)","pl":"Sint Maarten (część niderlandzka)"}',
        18.03333300,
        -63.05000000,
        '🇸🇽',
        'U+1F1F8 U+1F1FD',
        '2020-12-06 05:33:39',
        '2023-08-10 00:53:19',
        1,
        'Q26273'
    );

-- #endregion COUNTRIES
-- #region COUNTRY_MODIFICATIONS
DELETE FROM countries
WHERE
    temp_region_id IS NULL;

UPDATE countries
SET
    region_id = '44257098-ebbc-4288-a53e-c0c74dd79f0b' -- Africa
WHERE
    temp_region_id = 1;

UPDATE countries
SET
    region_id = '586f2a1b-ad75-4dbc-8381-0cf26a48929d' -- Americas
WHERE
    temp_region_id = 2;

UPDATE countries
SET
    region_id = '847f59ee-a9ac-4552-bd26-3003d6f3df80' -- Asia
WHERE
    temp_region_id = 3;

UPDATE countries
SET
    region_id = '081be89e-e707-451c-a04c-51a994aeb058' -- Europe
WHERE
    temp_region_id = 4;

UPDATE countries
SET
    region_id = '209ccf09-dc1b-45d3-8b79-a400fa72c744' -- Oceania
WHERE
    temp_region_id = 5;

UPDATE countries
SET
    subregion_id = '257da5dd-4303-4d9f-8270-a560c8d946ae'
WHERE
    temp_subregion_id = 1;

UPDATE countries
SET
    subregion_id = 'db6f6a6f-ac9d-4374-8a81-e12a56dceb8f'
WHERE
    temp_subregion_id = 2;

UPDATE countries
SET
    subregion_id = '82d1178f-8238-4466-bf2b-23e8a95e9344'
WHERE
    temp_subregion_id = 3;

UPDATE countries
SET
    subregion_id = 'a47c2972-c70d-4c03-b635-1060b6d8b228'
WHERE
    temp_subregion_id = 4;

UPDATE countries
SET
    subregion_id = 'd6a4bf48-5b45-4a28-9e24-5af5c2c9a76f'
WHERE
    temp_subregion_id = 5;

UPDATE countries
SET
    subregion_id = '11b0736f-07c3-42e5-b434-a5af08c05af0'
WHERE
    temp_subregion_id = 6;

UPDATE countries
SET
    subregion_id = 'a0f8efd8-72be-47aa-aedf-7a7473fdc4c5'
WHERE
    temp_subregion_id = 7;

UPDATE countries
SET
    subregion_id = 'ec851ade-8eca-442c-894c-260dc960b930'
WHERE
    temp_subregion_id = 8;

UPDATE countries
SET
    subregion_id = '1cdc20c3-9873-4dd9-973b-e27a5ab31881'
WHERE
    temp_subregion_id = 9;

UPDATE countries
SET
    subregion_id = '47a247c2-63f1-46c3-b9e9-234d6e25836f'
WHERE
    temp_subregion_id = 10;

UPDATE countries
SET
    subregion_id = '02567284-8081-4b81-8ba9-d668073e8321'
WHERE
    temp_subregion_id = 11;

UPDATE countries
SET
    subregion_id = 'ae0c6a46-d55e-4e52-8ffc-d0367c2623cf'
WHERE
    temp_subregion_id = 12;

UPDATE countries
SET
    subregion_id = '72beac8e-ccef-4285-b3be-5373f69da329'
WHERE
    temp_subregion_id = 13;

UPDATE countries
SET
    subregion_id = '28d46c29-0171-4337-a853-f74df9a9ae2c'
WHERE
    temp_subregion_id = 14;

UPDATE countries
SET
    subregion_id = '370b6713-d88d-4640-a9a8-2f855b5bf304'
WHERE
    temp_subregion_id = 15;

UPDATE countries
SET
    subregion_id = '870236e5-493d-4f35-ad65-4102137f3131'
WHERE
    temp_subregion_id = 16;

UPDATE countries
SET
    subregion_id = '2f4c0766-b497-4146-a0a0-581e02c2e292'
WHERE
    temp_subregion_id = 17;

UPDATE countries
SET
    subregion_id = 'b809c2e0-40a9-43b1-87df-9efaf1bf6069'
WHERE
    temp_subregion_id = 18;

UPDATE countries
SET
    subregion_id = 'c500a779-15a7-49a9-9bae-43394c7e59b5'
WHERE
    temp_subregion_id = 19;

UPDATE countries
SET
    subregion_id = '45fb0ccf-c5db-4ab2-acb6-eed633154336'
WHERE
    temp_subregion_id = 20;

UPDATE countries
SET
    subregion_id = 'b9ad9fb2-e9b3-49b5-9604-2f344e48db39'
WHERE
    temp_subregion_id = 21;

UPDATE countries
SET
    subregion_id = 'da7e1ca7-8a96-40ee-b26b-5c7a1b921f2e'
WHERE
    temp_subregion_id = 22;

UPDATE countries
SET
    title = TRIM(title);

ALTER TABLE countries
DROP column temp_id;

ALTER TABLE countries
DROP column temp_region_id;

ALTER TABLE countries
DROP column temp_subregion_id;

ALTER TABLE countries
DROP column native;

ALTER TABLE countries
DROP column region;

ALTER TABLE countries
DROP column subregion;

ALTER TABLE countries
DROP column translations;

ALTER TABLE countries
DROP column emoji;

ALTER TABLE countries
DROP column "emojiU";

ALTER TABLE countries
DROP column created_at;

ALTER TABLE countries
DROP column updated_at;

ALTER TABLE countries
DROP column flag;

ALTER TABLE countries
ALTER COLUMN region_id
SET NOT NULL;

ALTER TABLE countries
ALTER COLUMN subregion_id
SET NOT NULL;

-- #endregion COUNTRY_MODIFICATIONS
-- migrate:down
DROP TABLE IF EXISTS countries;

DROP TABLE IF EXISTS subregions;

DROP TABLE IF EXISTS regions;