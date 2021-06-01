Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EEEC4708F
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Jun 2021 06:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BAEA61370
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Jun 2021 06:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhFAG4P (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 02:56:15 -0400
Received: from mx-relay06-hz2.antispameurope.com ([83.246.65.92]:58423 "EHLO
        mx-relay06-hz2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231139AbhFAG4L (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Jun 2021 02:56:11 -0400
Received: from smtp-out.all-for-one.com ([91.229.168.76]) by mx-relay06-hz2.antispameurope.com;
 Tue, 01 Jun 2021 08:54:27 +0200
Received: from bruexc105.brumgt.local (10.251.3.41) by bruexc106.brumgt.local
 (10.251.3.42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2176.14; Tue, 1 Jun
 2021 08:53:45 +0200
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (10.251.3.124) by
 bruexc105.brumgt.local (10.251.3.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2176.14 via Frontend Transport; Tue, 1 Jun 2021 08:53:45 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4i/+EEt5PIqxeVrs2qqp51MaxLpUBoUELjcAVFC1V/o6HzmpRCXRkhirEjhoaWFXoCmcPiLkBTVjrfTdPzJxwLX9pVKpGYLo4H0OHaSzqkBHt/hHDCI29VcHd55Zq+uJeMeRkNlheA0thVmis0ibqYlLC4XUuc8SHffvVdIN2wuQYLXoXh92aEQDOSXgb8bkh+w/fp/18m5AF1YLfUmMM4HR7UYqrbOEQ7z4QzGFgvWdUEjcvikl2C8VzlBeBghIQwFC4z4QX4carHWgExgZPiza6Kg5zuXmEMCh3M/HwTIxjnKg12YYcI8RfyNXc8HOoy+WSwjLpbWsj3ZVOzN5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHqVoAJTGH59YqhxorLdVcW9cTBE5O60QKWnaxllWdE=;
 b=N1WB8NOkpgAOxZSJUQKTJvqggTFWWV+tbKEmPrgEH8IOrdo1ybzwA10eDdT30RotHcHYCS7MpvEdPxXd8Pg4ByuRYmS3papu5E0cRCulGx2+93OALJew7dLYiVFe+hDZlhO0wxmJ5VY9qiETGNKwYGdAoStijBtBd/k41swQsl338hsmBrdK08rUYDm24kEFSFmiP2zINJ2XHOyoJ6xye/fag/e7iaAwKATatuPhna1vFSaqE7ZoZLpuz5mCbjGxlnn+9HLGnb9/IF9eyUQG9X8opm63W3DqvOQEPw1R3zjoOZouayyGWQvU3tJu7ZJip0ChvAz7d9swJ3zjBH77aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bruker.com; dmarc=pass action=none header.from=bruker.com;
 dkim=pass header.d=bruker.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Bruker.onmicrosoft.com; s=selector2-Bruker-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHqVoAJTGH59YqhxorLdVcW9cTBE5O60QKWnaxllWdE=;
 b=YCRJggAP4fALLtUF+DrZqQAYNWvLNnL7UXCNbaXMIUyaJjcnq8XNLX9KETAB5BH+ram+D3wScLDO6QNpyJmbSykvXbAyGbIQjVGd9p5xIl2NK5/0jOwJLlldfjj9SIa6PZMUt8jWwXvsW9GuAgCYkWeKSAGYwUP3dbWz3b43riQ=
Received: from AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1ef::11)
 by AM9PR10MB4547.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:270::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 1 Jun
 2021 06:53:44 +0000
Received: from AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::94a8:c32c:b493:492]) by AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::94a8:c32c:b493:492%8]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 06:53:44 +0000
From:   "Yurkov, Vyacheslav" <Vyacheslav.Yurkov@bruker.com>
To:     Amir Goldstein <amir73il@gmail.com>,
        Vyacheslav Yurkov <uvv.mail@gmail.com>
CC:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: RE: [PATCH v3 3/3] ovl: do not set overlay.opaque for new directories
Thread-Topic: [PATCH v3 3/3] ovl: do not set overlay.opaque for new
 directories
Thread-Index: AQHXUyA61HvbKJzzA0O5XB6kOjqqpqr4xcYAgAX4DAA=
Date:   Tue, 1 Jun 2021 06:53:43 +0000
Message-ID: <AM8PR10MB4161DB3BDC0D415D5D3D5154863E9@AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM>
References: <20210527174547.109269-1-uvv.mail@gmail.com>
 <20210527174547.109269-3-uvv.mail@gmail.com>
 <CAOQ4uxh7eSy6xAr9HdtZ=trcpUs8O5exXWJ8uqo2bacfMZXz3Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxh7eSy6xAr9HdtZ=trcpUs8O5exXWJ8uqo2bacfMZXz3Q@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_e340eb20-1c5f-4409-b1a4-85adc943d5d7_Enabled=true;
 MSIP_Label_e340eb20-1c5f-4409-b1a4-85adc943d5d7_SetDate=2021-06-01T06:53:42Z;
 MSIP_Label_e340eb20-1c5f-4409-b1a4-85adc943d5d7_Method=Standard;
 MSIP_Label_e340eb20-1c5f-4409-b1a4-85adc943d5d7_Name=Confidential;
 MSIP_Label_e340eb20-1c5f-4409-b1a4-85adc943d5d7_SiteId=375ce1b8-8db1-479b-a12c-06fa9d2a2eaf;
 MSIP_Label_e340eb20-1c5f-4409-b1a4-85adc943d5d7_ActionId=b35a738c-82b0-4158-8a03-b120ceb41cdf;
 MSIP_Label_e340eb20-1c5f-4409-b1a4-85adc943d5d7_ContentBits=2
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bruker.com;
x-originating-ip: [2.205.242.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc0026c4-4da2-4c9a-62ea-08d924c9ff66
x-ms-traffictypediagnostic: AM9PR10MB4547:
x-microsoft-antispam-prvs: <AM9PR10MB454732ACBD77026C90256FF8863E9@AM9PR10MB4547.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YgFd+5QPq3zL4OfbGiA2nPgCuobdOS8vqot6UTKy5vhVTdwoj2b/nvjTNMFuiipdaG2JtnvEv1oDK54G0xNUeHs2WIw3MFVa1odZD/7AqbOJR9OXhrHuZibSsDB/mm7tC/u1C3M0TtskUopq8g1BK3MRrqNvRdGs3Iv7T5DiM1Asj02CRcNJGoAbDT5iH5kbiJ3eYY3/w6xlgm5ghka0J0cRmt92kQliGDYUllLo0KjKVxP8QeWIKoC8toqHfQjRlA7enhRlVoybTUe5/k9M3wNnsvAkB9HXlgnvvKL54rTSgK/U8NRkM+9IuoD4PfCKpxg8ubkljYu7qNhEPfoBc3naHOOjh1KawmYjb/ZGSvWbhfP+xRqYQJq3xn/aArxp+R5Jv5pJjk6N5MLfdJbXcOiPEcA2JEINoBtfl6FxsM5hYbq2sCEu6KB7G4O2zFIlI/NhX1Blqc2pM+bcjzmCp/UoxDD6ySPoRV08A79MMmeRLMO6uvILS8M8EVJ48kDTxqJ7K4rmED7qA7VL25YDQ2vY6sOH46wzzYahNXN3TWOAsoHq0XvKbh7RcWjPHBdTXuFY8DA2Sao7aaA6TNgr+WlHr0JOO0UuHDiyGnaw3sk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(33656002)(66476007)(71200400001)(478600001)(64756008)(66446008)(8676002)(52536014)(5660300002)(53546011)(186003)(2906002)(66616009)(66556008)(6506007)(99936003)(8936002)(76116006)(7696005)(86362001)(38100700002)(122000001)(4326008)(54906003)(110136005)(26005)(83380400001)(316002)(55016002)(9686003)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SVFqdnhZcEhLMW1Mb09udTdCZmpNelNzOHNwc3V6R3o2eHJDM0daditjcDM2?=
 =?utf-8?B?TlNuekpVU2xEdTBEQ252aTlDVGxjWmRKUjFlcmJlQytGZG1xb285NjcvTWV3?=
 =?utf-8?B?QXNIeXc4d1crZVJWVjF3TFNoMGVRUmhWSElGSXd2bCtQVmp4YVF0eVNUWDNr?=
 =?utf-8?B?VkZYUTErNWlSM0dmZ3h2Y2xJalQzZW1hOG5LWDRCZE5IU1BpaUtFVHpjeTd4?=
 =?utf-8?B?UHZKcUpmU1lVSTNPWGhnUXYzNFpLSGltY1lkK20ya3hrVFJwaWwrak9ldDJr?=
 =?utf-8?B?SWM0RzVQSXI4Y0gwejJrekk4VXI3NzRud2lRRjJqZGFMT2V6YW1YaE9RREUz?=
 =?utf-8?B?OE1HU1lBeEJneUdFemRqQjhKZGFubGR5MWpqYWM5MVBscWtITStLd0h6U2ZK?=
 =?utf-8?B?YkM5M2hQb0xNNlVvYWZIdmJ0TWh4a0tPdnZCakNSRUZ5WjRRTHZSMGo2OFZm?=
 =?utf-8?B?dVp4aWNNRThOajRnQmg4THcwMEhJZ3FwdXExWG9wYXlQUGJuZy9oL0pvMExB?=
 =?utf-8?B?UzI5RGd5cXhVanU0SHdyZ3VaMTJrbGtQY2NBMUJyV0gzK0JWWk5HUW9kZVds?=
 =?utf-8?B?SmVCaktyeGc3eVl6QysrODd4eWlIL2dKdXBucTNpVC9BNlM0bjhWbjFJbElr?=
 =?utf-8?B?djFlcDlOY3pQYkhkY2tjVDRPSEFXbXY3WjViU01wWFd4Y0llR1I2emFMUjhi?=
 =?utf-8?B?Qk41ZVBiWXpLdXpwcUZHVHZMZ000T0VQVlJOQUJEaXhrMzVhQnMxaFE2ekh3?=
 =?utf-8?B?ZFB0Z2d3dlZHSGYvM2ZTVXZpajNjczErbHNNdzY4dHFnSFRBcEhJZXNUR29V?=
 =?utf-8?B?c1J6MXVzUkpIWWFiam5TV21zdUNNSXI4dDBHeXJGU2l6cXdJTnZmdTlwQnpZ?=
 =?utf-8?B?MVQ0MXF2aDYvaG0vWFpzU2ZpeWpCamx5VDlnazltWVFZNGQxRjljUTNqc3Qy?=
 =?utf-8?B?TnhsU056VmtXYzRNTk1BQkNvVWpJa3lNbVZLcTVJcjRFRHlhMzIvZ3lLY1B2?=
 =?utf-8?B?U2tZOXN0TC92Zi81MExVNk9oZ1ZUVHBMbUoyRmQ5blVnUUFBOE1oQ2czdjZL?=
 =?utf-8?B?U2FrQ0NjYzNudEk4ZmRBUzNHVnlQM2tXWmRIVy9laTB3TFR2UVI1UkdsbXBW?=
 =?utf-8?B?WlZlSC9mOXFuK2NUbkxYTkN0dVpUaU9KWU9EWEU5ZElTV0I4eEhIUEQ2WlJn?=
 =?utf-8?B?dU5xVnRNUm1FeFpTK2o5MloxTGd2VnBMemJKdjk1dFVoVmtIWXBXTDBFc2VX?=
 =?utf-8?B?bXl2RWRaRUF2OXpGMlprN1BVcHBweExWQVdybXF1TXl5M2Q1VlJHLzZiVWl5?=
 =?utf-8?B?ckMreU0yVVI2RXU2ekQ4a205WUhTWDNBS3FOWTNMWFIyZE9xR0F0QmZPMEdF?=
 =?utf-8?B?T0k5SWtpSm5KdVIxMGlBYkVNSXpFY2NYcEFUVGxYcmFBUWhQS2ZMMzlEZG5w?=
 =?utf-8?B?U3BHS24xVXBGVGJwcGVEbTZmODlsYWl3bFpiTWtUV1JYNWFJUzFLTUl6L1lV?=
 =?utf-8?B?WG9QcmdwQXpkT2txbVpwMmZUQmZwRExFN3VuNVdacUFKR0VMSmpSSXp3UVVz?=
 =?utf-8?B?TFNVSCtxeVJZL0pIcFg5bU0yMzNoY2NCZWszdWt2K1ZkVng2ZlkxeEVucXBa?=
 =?utf-8?B?Z1NRaXVXVWNVdDdiWFZRMVJpcWx6ODk1d0VtOWJ1S1NBSHJoRHFtMXVVMFBa?=
 =?utf-8?B?Q1ZIZ2RMMDNFVHJyeURvR2lzN2tBbXNtQ0E2V21hWHRDZ2tBK0VDcjI4RU50?=
 =?utf-8?Q?XzmM3fwqhv83iAG1D3PDRbx0MCeYEgfKtz2Z15x?=
x-ms-exchange-transport-forked: True
Content-Type: multipart/mixed;
        boundary="_002_AM8PR10MB4161DB3BDC0D415D5D3D5154863E9AM8PR10MB4161EURP_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: cc0026c4-4da2-4c9a-62ea-08d924c9ff66
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2021 06:53:44.0138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 375ce1b8-8db1-479b-a12c-06fa9d2a2eaf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LaZldmUGH7P+R9hxMTd7vpuuTIAjR+cmk5QWi9TFqMo2YRyD5TjIXpaTHKr+kDks0C6cjCrLT0+LZfQPoUAdlYgM4yHotmXXOCO2u+5yeSo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4547
X-OriginatorOrg: bruker.com
X-cloud-security-sender: vyacheslav.yurkov@bruker.com
X-cloud-security-recipient: linux-unionfs@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay06-hz2.antispameurope.com with 5A50654267F
X-cloud-security-connect: smtp-out.all-for-one.com[91.229.168.76], TLS=1, IP=91.229.168.76
X-cloud-security-Digest: 71b644240261bf6fb8d6d6c99e7f8b01
X-cloud-security: scantime:1.780
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--_002_AM8PR10MB4161DB3BDC0D415D5D3D5154863E9AM8PR10MB4161EURP_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgQW1pciwNClRoYW5rcyBhZ2FpbiBmb3IgdGhlIHJldmlldyBhbmQgYSBoZWFkcy11cCBhYm91
dCB0aGUgdGVzdHMuIEkgd2FzIG5vdCBhd2FyZSB0aGV5IGV4aXN0Lg0KDQpJdCB0b29rIG1lIHNv
bWUgdGltZSB0byBzZXQgdGhlbSB1cCBkdWUgdG8gcmVhbGx5IHBlY3VsaWFyIE1ha2VmaWxlLCBi
dXQgSSBub3cgZXZlbiBoYXZlIGEgeW9jdG8gcmVjaXBlIHRvIGJ1aWxkIHRoZW0gKHdpbGwgZmls
ZSBpdCB1cHN0cmVhbSBsYXRlcikuDQoNClRoZSBsYXRlc3QgbWFzdGVyIGFuZCBteSB2MyBib3Ro
IHJlcG9ydCB0aGUgc2FtZSByZXN1bHRzOg0KRmFpbHVyZXM6IG92ZXJsYXkvMDA1IG92ZXJsYXkv
MDY1IG92ZXJsYXkvMDc1DQpGYWlsZWQgMyBvZiA5MyB0ZXN0cw0KKFRoZSBmdWxsIGxvZyBpcyBh
dHRhY2hlZCkNCg0KSSBhc3N1bWUgdGhlIGZhaWx1cmVzIGNvbWUgZHVlIHRvIG15IHNwZWNpZmlj
IGNvbmZpZ3VyYXRpb24sIGJ1dCBzaW5jZSBtYXN0ZXIgYW5kIHYzIGlzc3VlIHRoZSBzYW1lIHJl
c3VsdHMgSSBzaG91bGQgYmUgZmluZSBoZXJlLg0KDQp2MiBpbmRlZWQgY2F1c2VkIGEgZmV3IG1v
cmUgZmFpbHVyZXMgb24gdG9wIG9mIHRoYXQ6DQpGYWlsdXJlczogb3ZlcmxheS8wMDUgb3Zlcmxh
eS8wNjUgb3ZlcmxheS8wNzAgb3ZlcmxheS8wNzEgb3ZlcmxheS8wNzUNCkZhaWxlZCA1IG9mIDkz
IHRlc3RzDQoNCkNvdWxkIHlvdSBwbGVhc2UgdGVsbCBtZSBqdXN0IGZvciBteSBpbmZvcm1hdGlv
biB3aGF0J3MgdGhlIHVzdWFsIHRpbWUgZnJhbWUgdG8gaGF2ZSBteSB2MyBtYWlubGluZWQ/DQoN
ClRoYW5rcywNClZ5YWNoZXNsYXYNCg0KDQotIGNvbmZpZGVudGlhbCAtDQoNCj4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW1pciBHb2xkc3RlaW4gPGFtaXI3M2lsQGdtYWls
LmNvbT4NCj4gU2VudDogRnJpZGF5LCBNYXkgMjgsIDIwMjEgMTM6MzkNCj4gVG86IFZ5YWNoZXNs
YXYgWXVya292IDx1dnYubWFpbEBnbWFpbC5jb20+DQo+IENjOiBNaWtsb3MgU3plcmVkaSA8bWlr
bG9zQHN6ZXJlZGkuaHU+OyBvdmVybGF5ZnMgPGxpbnV4LQ0KPiB1bmlvbmZzQHZnZXIua2VybmVs
Lm9yZz47IFl1cmtvdiwgVnlhY2hlc2xhdg0KPiA8VnlhY2hlc2xhdi5ZdXJrb3ZAYnJ1a2VyLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MyAzLzNdIG92bDogZG8gbm90IHNldCBvdmVybGF5
Lm9wYXF1ZSBmb3IgbmV3DQo+IGRpcmVjdG9yaWVzDQo+IA0KPiAqKkVYVEVSTkFMIEVNQUlMKioN
Cj4gDQo+IE9uIFRodSwgTWF5IDI3LCAyMDIxIGF0IDg6NDYgUE0gVnlhY2hlc2xhdiBZdXJrb3Yg
PHV2di5tYWlsQGdtYWlsLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gPiBGcm9tOiBWeWFjaGVzbGF2
IFl1cmtvdiA8VnlhY2hlc2xhdi5ZdXJrb3ZAYnJ1a2VyLmNvbT4NCj4gPg0KPiA+IEVuYWJsZSBv
cHRpbWl6YXRpb25zIG9ubHkgaWYgdXNlciBvcHRlZC1pbiBmb3IgYW55IG9mIGV4dGVuZGVkIGZl
YXR1cmVzLg0KPiA+IElmIG9wdGltaXphdGlvbiBpcyBlbmFibGVkLCBpdCBicmVha3MgZXhpc3Rp
bmcgdXNlIGNhc2Ugd2hlbiBhIGxvd2VyIGxheWVyDQo+ID4gZGlyZWN0b3J5IGFwcGVhcnMgYWZ0
ZXIgZGlyZWN0b3J5IHdhcyBjcmVhdGVkIG9uIGEgbWVyZ2VkIGxheWVyLiBJZg0KPiA+IG92ZXJs
YXkub3BhcXVlIGlzIGFwcGxpZWQsIG5ldyBmaWxlcyBvbiBsb3dlciBsYXllciBhcmUgbm90IHZp
c2libGUuDQo+ID4NCj4gPiBDb25zaWRlciB0aGUgZm9sbG93aW5nIHNjZW5hcmlvOg0KPiA+IC0g
L2xvd2VyIGFuZCAvdXBwZXIgYXJlIG1vdW50ZWQgdG8gL21lcmdlZA0KPiA+IC0gZGlyZWN0b3J5
IC9tZXJnZWQvbmV3LWRpciBpcyBjcmVhdGVkIHdpdGggYSBmaWxlIHRlc3QxDQo+ID4gLSBvdmVy
bGF5IGlzIHVubW91bnRlZA0KPiA+IC0gZGlyZWN0b3J5IC9sb3dlci9uZXctZGlyIGlzIGNyZWF0
ZWQgd2l0aCBhIGZpbGUgdGVzdDINCj4gPiAtIG92ZXJsYXkgaXMgbW91bnRlZCBhZ2Fpbg0KPiA+
DQo+ID4gSWYgb3BhcXVlIGlzIGFwcGxpZWQgYnkgZGVmYXVsdCwgZmlsZSB0ZXN0MiBpcyBub3Qg
Z29pbmcgdG8gYmUgdmlzaWJsZQ0KPiA+IHdpdGhvdXQgZXhwbGljaXRseSBjbGVhcmluZyB0aGUg
b3ZlcmxheS5vcGFxdWUgYXR0cmlidXRlDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBWeWFjaGVz
bGF2IFl1cmtvdiA8VnlhY2hlc2xhdi5ZdXJrb3ZAYnJ1a2VyLmNvbT4NCj4gPiAtLS0NCj4gDQo+
IFZ5YWNoZXNsYXYsDQo+IA0KPiBUaGUgc2VyaWVzIGxvb2tzIGdvb2QuDQo+IEluIGNhc2UgeW91
IHBvc3QgYW5vdGhlciB2ZXJzaW9uIHBsZWFzZSBhZGQ6DQo+IFJldmlld2VkLWJ5OiBBbWlyIEdv
bGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPg0KPiANCj4gTm8gbmVlZCB0byByZXBvc3QganVz
dCBmb3IgdGhhdC4NCj4gDQo+IERpZCB5b3UgaGFwcGVuIHRvIHJ1biB4ZnN0ZXN0cyBvbiB0aGVz
ZSBwYXRjaGVzPw0KPiANCj4gSWYgSSBhbSBub3QgbWlzdGFrZW4sIHRlc3RzIG92ZXJsYXkvMDY4
IGFuZCBvdmVybGF5LzA2OSBwcm92aWRlDQo+IHRlc3QgY292ZXJhZ2UgdG8gdGhlIGNoZWNrIGlu
IG92bF9sb3dlcl91dWlkX29rKCkgZm9yIHRoZSBjYXNlDQo+IG9mIGxvd2VyIG51bGwgdXVpZCAo
bG93ZXIgb3ZlcmxheWZzKSBhbmQgdXNlciBvcHQtaW4gdG8gbmV3IGZlYXR1cmVzDQo+IChuZnNf
ZXhwb3J0KSwgc28gdGVzdHMgd291bGQgaGF2ZSBjYXVnaHQgdGhlIGJ1ZyB5b3UgaGFkIGluIHYy
Lg0KPiANCj4gUGxlYXNlIHZlcmlmeSB0aGF0IEkgYW0gbm90IHdyb25nIChhYm91dCB0ZXN0IGNh
dGNoaW5nIHYyIGJ1ZykgYW5kDQo+IHRoYXQgdjMgcGFzc2VzIGF0IGxlYXN0Og0KPiAuL2NoZWNr
IC1vdmVybGF5IC1nIG92ZXJsYXkvcXVpY2sgLWcgb3ZlcmxheS91bmlvbg0KPiANCj4gUGxlYXNl
IHNlZSBSRUFETUUub3ZlcmxheSBpbiB4ZnN0ZXN0cyBmb3Igc2V0dGluZyB1cCB0byBydW4NCj4g
Li9jaGVjayAtb3ZlcmxheSBhbmQgdGhlIHVuaW9ubW91bnQgdGVzdHMuDQo+IA0KPiBUaGFua3Ms
DQo+IEFtaXIuDQo+IA0KPiANCj4gPiAgZnMvb3ZlcmxheWZzL2Rpci5jIHwgNCArKystDQo+ID4g
IDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+
IGRpZmYgLS1naXQgYS9mcy9vdmVybGF5ZnMvZGlyLmMgYi9mcy9vdmVybGF5ZnMvZGlyLmMNCj4g
PiBpbmRleCA5M2VmZTcwNDhhNzcuLjAzYTIyOTU0ZmU2MSAxMDA2NDQNCj4gPiAtLS0gYS9mcy9v
dmVybGF5ZnMvZGlyLmMNCj4gPiArKysgYi9mcy9vdmVybGF5ZnMvZGlyLmMNCj4gPiBAQCAtMzIw
LDYgKzMyMCw3IEBAIHN0YXRpYyBib29sIG92bF90eXBlX29yaWdpbihzdHJ1Y3QgZGVudHJ5ICpk
ZW50cnkpDQo+ID4gIHN0YXRpYyBpbnQgb3ZsX2NyZWF0ZV91cHBlcihzdHJ1Y3QgZGVudHJ5ICpk
ZW50cnksIHN0cnVjdCBpbm9kZSAqaW5vZGUsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHN0cnVjdCBvdmxfY2F0dHIgKmF0dHIpDQo+ID4gIHsNCj4gPiArICAgICAgIHN0cnVjdCBv
dmxfZnMgKm9mcyA9IE9WTF9GUyhkZW50cnktPmRfc2IpOw0KPiA+ICAgICAgICAgc3RydWN0IGRl
bnRyeSAqdXBwZXJkaXIgPSBvdmxfZGVudHJ5X3VwcGVyKGRlbnRyeS0+ZF9wYXJlbnQpOw0KPiA+
ICAgICAgICAgc3RydWN0IGlub2RlICp1ZGlyID0gdXBwZXJkaXItPmRfaW5vZGU7DQo+ID4gICAg
ICAgICBzdHJ1Y3QgZGVudHJ5ICpuZXdkZW50cnk7DQo+ID4gQEAgLTMzOCw3ICszMzksOCBAQCBz
dGF0aWMgaW50IG92bF9jcmVhdGVfdXBwZXIoc3RydWN0IGRlbnRyeSAqZGVudHJ5LA0KPiBzdHJ1
Y3QgaW5vZGUgKmlub2RlLA0KPiA+ICAgICAgICAgaWYgKElTX0VSUihuZXdkZW50cnkpKQ0KPiA+
ICAgICAgICAgICAgICAgICBnb3RvIG91dF91bmxvY2s7DQo+ID4NCj4gPiAtICAgICAgIGlmIChv
dmxfdHlwZV9tZXJnZShkZW50cnktPmRfcGFyZW50KSAmJiBkX2lzX2RpcihuZXdkZW50cnkpKSB7
DQo+ID4gKyAgICAgICBpZiAob3ZsX3R5cGVfbWVyZ2UoZGVudHJ5LT5kX3BhcmVudCkgJiYgZF9p
c19kaXIobmV3ZGVudHJ5KSAmJg0KPiA+ICsgICAgICAgICAgICFvdmxfYWxsb3dfb2ZmbGluZV9j
aGFuZ2VzKG9mcykpIHsNCj4gPiAgICAgICAgICAgICAgICAgLyogU2V0dGluZyBvcGFxdWUgaGVy
ZSBpcyBqdXN0IGFuIG9wdGltaXphdGlvbiwgYWxsb3cgdG8gZmFpbCAqLw0KPiA+ICAgICAgICAg
ICAgICAgICBvdmxfc2V0X29wYXF1ZShkZW50cnksIG5ld2RlbnRyeSk7DQo+ID4gICAgICAgICB9
DQo+ID4gLS0NCj4gPiAyLjI1LjENCj4gPg0K

--_002_AM8PR10MB4161DB3BDC0D415D5D3D5154863E9AM8PR10MB4161EURP_
Content-Type: application/octet-stream; name="check-patched.log"
Content-Description: check-patched.log
Content-Disposition: attachment; filename="check-patched.log"; size=1587;
	creation-date="Tue, 01 Jun 2021 06:44:38 GMT";
	modification-date="Tue, 01 Jun 2021 06:44:38 GMT"
Content-Transfer-Encoding: base64

ClR1ZSBKdW4gIDEgMDY6NDY6MzYgVVRDIDIwMjEKUmFuOiBvdmVybGF5LzAwMSBvdmVybGF5LzAw
MiBvdmVybGF5LzAwMyBvdmVybGF5LzAwNCBvdmVybGF5LzAwNSBvdmVybGF5LzAwNiBvdmVybGF5
LzAwNyBvdmVybGF5LzAwOCBvdmVybGF5LzAwOSBvdmVybGF5LzAxMCBvdmVybGF5LzAxMSBvdmVy
bGF5LzAxMiBvdmVybGF5LzAxMyBvdmVybGF5LzAxNCBvdmVybGF5LzAxNSBvdmVybGF5LzAxNiBv
dmVybGF5LzAxNyBvdmVybGF5LzAxOCBvdmVybGF5LzAyMCBvdmVybGF5LzAyMSBvdmVybGF5LzAy
MiBvdmVybGF5LzAyMyBvdmVybGF5LzAyNCBvdmVybGF5LzAyNSBvdmVybGF5LzAyNiBvdmVybGF5
LzAyNyBvdmVybGF5LzAyOCBvdmVybGF5LzAyOSBvdmVybGF5LzAzMCBvdmVybGF5LzAzMSBvdmVy
bGF5LzAzMiBvdmVybGF5LzAzMyBvdmVybGF5LzAzNCBvdmVybGF5LzAzNSBvdmVybGF5LzAzNiBv
dmVybGF5LzAzNyBvdmVybGF5LzAzOCBvdmVybGF5LzAzOSBvdmVybGF5LzA0MCBvdmVybGF5LzA0
MSBvdmVybGF5LzA0MiBvdmVybGF5LzA0MyBvdmVybGF5LzA0NCBvdmVybGF5LzA0NSBvdmVybGF5
LzA0NiBvdmVybGF5LzA0NyBvdmVybGF5LzA0OCBvdmVybGF5LzA0OSBvdmVybGF5LzA1MCBvdmVy
bGF5LzA1MSBvdmVybGF5LzA1MiBvdmVybGF5LzA1MyBvdmVybGF5LzA1NCBvdmVybGF5LzA1NSBv
dmVybGF5LzA1NiBvdmVybGF5LzA1NyBvdmVybGF5LzA1OCBvdmVybGF5LzA1OSBvdmVybGF5LzA2
MCBvdmVybGF5LzA2MiBvdmVybGF5LzA2MyBvdmVybGF5LzA2NCBvdmVybGF5LzA2NSBvdmVybGF5
LzA2NiBvdmVybGF5LzA2NyBvdmVybGF5LzA2OCBvdmVybGF5LzA2OSBvdmVybGF5LzA3MCBvdmVy
bGF5LzA3MSBvdmVybGF5LzA3MiBvdmVybGF5LzA3MyBvdmVybGF5LzA3NCBvdmVybGF5LzA3NSBv
dmVybGF5LzA3NiBvdmVybGF5LzA3NyBvdmVybGF5LzEwMCBvdmVybGF5LzEwMSBvdmVybGF5LzEw
MiBvdmVybGF5LzEwMyBvdmVybGF5LzEwNCBvdmVybGF5LzEwNSBvdmVybGF5LzEwNiBvdmVybGF5
LzEwNyBvdmVybGF5LzEwOCBvdmVybGF5LzEwOSBvdmVybGF5LzExMCBvdmVybGF5LzExMSBvdmVy
bGF5LzExMiBvdmVybGF5LzExMyBvdmVybGF5LzExNCBvdmVybGF5LzExNSBvdmVybGF5LzExNiBv
dmVybGF5LzExNwpOb3QgcnVuOiBvdmVybGF5LzAwMSBvdmVybGF5LzAwNCBvdmVybGF5LzAwOCBv
dmVybGF5LzAxNSBvdmVybGF5LzAyMCBvdmVybGF5LzAyMSBvdmVybGF5LzAyNSBvdmVybGF5LzAz
MiBvdmVybGF5LzA0NSBvdmVybGF5LzA0NiBvdmVybGF5LzA1NiBvdmVybGF5LzA2NCBvdmVybGF5
LzEwMCBvdmVybGF5LzEwMSBvdmVybGF5LzEwMiBvdmVybGF5LzEwMyBvdmVybGF5LzEwNCBvdmVy
bGF5LzEwNSBvdmVybGF5LzEwNiBvdmVybGF5LzEwNyBvdmVybGF5LzEwOCBvdmVybGF5LzEwOSBv
dmVybGF5LzExMCBvdmVybGF5LzExMSBvdmVybGF5LzExMiBvdmVybGF5LzExMyBvdmVybGF5LzEx
NCBvdmVybGF5LzExNSBvdmVybGF5LzExNiBvdmVybGF5LzExNwpGYWlsdXJlczogb3ZlcmxheS8w
MDUgb3ZlcmxheS8wNjUgb3ZlcmxheS8wNzUKRmFpbGVkIDMgb2YgOTMgdGVzdHMK

--_002_AM8PR10MB4161DB3BDC0D415D5D3D5154863E9AM8PR10MB4161EURP_--
