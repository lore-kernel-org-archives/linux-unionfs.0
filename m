Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF8FC47089
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 12:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25A12610CC
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 12:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbhE0M1g (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 May 2021 08:27:36 -0400
Received: from mx-relay07-hz2.antispameurope.com ([83.246.65.93]:36051 "EHLO
        mx-relay07-hz2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234352AbhE0M1g (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 May 2021 08:27:36 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 May 2021 08:27:35 EDT
Received: from smtp-out.all-for-one.com ([91.229.168.76]) by mx-relay07-hz2.antispameurope.com;
 Thu, 27 May 2021 14:20:51 +0200
Received: from bruexc106.brumgt.local (10.251.3.42) by bruexc105.brumgt.local
 (10.251.3.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2176.14; Thu, 27 May
 2021 14:18:56 +0200
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (10.251.3.124) by
 bruexc106.brumgt.local (10.251.3.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2176.14 via Frontend Transport; Thu, 27 May 2021 14:18:56 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2BLPULlHwD2USW/mjEm99BnZ1BYegWx7xlxy6e2Czq72rlClGEb7hBBHcJ9TamwbNQA4TbmNDL2UZ7N4bo2iYyD4VtoyiDUaNBn25aURkUWPVXITUgEjQOHWHh6F6a08f1yYfa9ZMYcOUhrpsEpUEhZHvY0OIHH9IpwAGhc+eJtahQxOXgvQN5EvwixLcV3ZPaKjTAbiBHhY1kJexBJqV6BCnSBB3iVu4CTi5oj5MikicCP1NKk6K4jOzTQh9NkUrEvFp4mYFf9/x9iZWZEW7ccWv1NSm9tG/8M4EOFF99NTbZJkFILRE3Sc1lDro4vcl2/98tXSFguysJShSqaeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEku+X1qQQR4CJg5aFktZjmlbOzTmK5qwN7P5GBy00c=;
 b=EIj4sg9nhncFc7/p8iihc7tL6v2q9qvL3SXJI8rqnnApvt/LRYk4tCxLp7oCgb+j+JLaMmgV7V16no6PzVJahcCZAEr8Qy2+FZjp97ZmD7HTBIcBQiUYmlC9mranRbmSE9q2cUnTkr1TmxSymyOvNGbkwZMhwKtMK74Awe7znTwSSZY/5p/Eu678JTQwENFb9RzGs+SyhszU2AvXGRJaNY58BHWftfJt78zgw8gSf3Z7Wn96X2HNi7/AQh4eYRCD28zmGWDpRpFhewei8tZ7MXKxDRB8Uq1PyCI4x8xpK62S4F2vXUno8fqympfE8xqYpUmtgw7yA7UQhXlqlRaA/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bruker.com; dmarc=pass action=none header.from=bruker.com;
 dkim=pass header.d=bruker.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Bruker.onmicrosoft.com; s=selector2-Bruker-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEku+X1qQQR4CJg5aFktZjmlbOzTmK5qwN7P5GBy00c=;
 b=DWoOcDcPH4PmN85mSaOqr0zUVGB/DaoNF8fk5z5TLcBGO1p/igM4grTB8y9MCfAT5oj3C+KRpBlHAm8zXSQvPHudcjkTMgNiyLRUYcKSCjI48Ouy/0obZuNQt07rHa5iV+d+N7yVRTQefP1kn0k9kUNvIbogjoUW7pxdkP9TP+A=
Received: from AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1ef::11)
 by AM0PR10MB2753.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:129::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Thu, 27 May
 2021 12:18:55 +0000
Received: from AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::94a8:c32c:b493:492]) by AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::94a8:c32c:b493:492%8]) with mapi id 15.20.4173.022; Thu, 27 May 2021
 12:18:55 +0000
From:   "Yurkov, Vyacheslav" <Vyacheslav.Yurkov@bruker.com>
To:     Amir Goldstein <amir73il@gmail.com>
CC:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: RE: [PATCH] ovl: do not set overlay.opaque for new directories
Thread-Topic: [PATCH] ovl: do not set overlay.opaque for new directories
Thread-Index: AQHXQExCKbcScGPkR0yELBTMfvilzKr0ACkAgAAF+tA=
Date:   Thu, 27 May 2021 12:18:55 +0000
Message-ID: <AM8PR10MB41616A1FD00E71B2F0F2390086239@AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM>
References: <20210503184258.96714-1-Vyacheslav.Yurkov@bruker.com>
 <CAOQ4uximN3=VQ=CYryGrrkdXn0GpXe=skrrRma07MMRvz_gByw@mail.gmail.com>
In-Reply-To: <CAOQ4uximN3=VQ=CYryGrrkdXn0GpXe=skrrRma07MMRvz_gByw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_e340eb20-1c5f-4409-b1a4-85adc943d5d7_Enabled=true;
 MSIP_Label_e340eb20-1c5f-4409-b1a4-85adc943d5d7_SetDate=2021-05-27T12:18:53Z;
 MSIP_Label_e340eb20-1c5f-4409-b1a4-85adc943d5d7_Method=Standard;
 MSIP_Label_e340eb20-1c5f-4409-b1a4-85adc943d5d7_Name=Confidential;
 MSIP_Label_e340eb20-1c5f-4409-b1a4-85adc943d5d7_SiteId=375ce1b8-8db1-479b-a12c-06fa9d2a2eaf;
 MSIP_Label_e340eb20-1c5f-4409-b1a4-85adc943d5d7_ActionId=c2c2158f-6ab7-46c2-a534-b66075f8aa1c;
 MSIP_Label_e340eb20-1c5f-4409-b1a4-85adc943d5d7_ContentBits=2
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bruker.com;
x-originating-ip: [2.205.242.53]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb7d4515-18bd-411b-6eba-08d9210998f4
x-ms-traffictypediagnostic: AM0PR10MB2753:
x-microsoft-antispam-prvs: <AM0PR10MB275353C32FEB0679B9CC58E786239@AM0PR10MB2753.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oeIoThvSofor8ZdEVsH1UVhOkS92ANNsSW20a6uHz/L0Et74EB2rwQrj4P7hi2mznmy4DiRC9ulW8MiuvxnaGz2McB0Tgo5yGfMoII5rRFc3pJBgu1j84/fyDLFio8eDjN1hfIdlWjRDMG8ttB813+TF/EatNJYseFGDNtJvXpvXYYtoHcT+4NaHXFNsD/1LgihBZ0NWFrrWGe+OxyGM6nLOAKHC0anmSwQO3JeE8WAGhrL4WXsVjo+jCqhDeY5u4GFhuYJBbi2j6J0ERRo5lAi6AiP+kkO0oTVc4O5oz5J1F0tHoVzrPLl4OrpeQW2GeqmujTBfW0TpmGykvCO6YxmxaGmX4j4aF3cwTOJeQD1aVxzHNI5AWgtWzZpb596IrFEITGnDEK0uxkDLpRR7Qp290PGlOp7xHowsVr7JL04Ff2SuusbleQ2L4dov50GK9ue546wjaKWS2laUEXysRi3ruEJ+QcunYYdHbWDilZt4QrjDMDcQVSpIaANNaiPuUyro1t/8NmXKSWqcm5XLAY6Ul6fdFU2DY652WnIuQc5R6CuvEHq/GMv95e0qkRp/w506eTmjhmG5EtuwVFdmUvbpNycAwKcBPG0z6DK9kOB/o1nxPqVH4rTeurDs0++qjfHkv8744klbULRgPsjzavn3ytfYwCNlAaGKLslY5CA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(316002)(66446008)(6506007)(66476007)(33656002)(66556008)(54906003)(64756008)(86362001)(7696005)(26005)(66946007)(8676002)(186003)(5660300002)(76116006)(52536014)(83380400001)(4326008)(8936002)(2906002)(38100700002)(122000001)(478600001)(9686003)(71200400001)(6916009)(53546011)(55016002)(309714004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UlM1bHpNdUoxYWJtTUF2VlJSN0xNZXB1dFZEbmQyZWw2Mm1Wb2F6Z2pjTlJE?=
 =?utf-8?B?aEViOWJtNnVjRThnNWtTcTg2Tk8vdnhESzg5V01vSWR6S3ZTY1ZkS3ljN3NO?=
 =?utf-8?B?YWR2bk1YZDhYZC9JRHpZZmpKelVZVDV6RmZCREJsV3VYY0YzQmRraFYzU0p3?=
 =?utf-8?B?N25ZQTM2TjExSGdOWmJDTnpDZ0RCYThhaldHMUgrcDIyeVN2RlBQUTFqL2Ja?=
 =?utf-8?B?djZhUkYvWG8yd1ZyQ1BFclBGeFhIaWg1bWQ2SEdWTzdXL2NkMVE0TitMRUpn?=
 =?utf-8?B?ZURKVDhERC9iYVRMOVhUWjBWRTNhbWRGNWJBWmZPRXJrd21ITmhNa0t3TWxO?=
 =?utf-8?B?RTBwaWlwajdTbVVtUlhDNjZFSnpBekNxd1FPalN6bGtrOFR5L3RaZ1R1bVpM?=
 =?utf-8?B?MERsMHpDd1d2ZE52K1J1cWpYZGxJK2tvRkNucm5uNVNxQ280ZVE4VFMreWgr?=
 =?utf-8?B?UUZycE8zZzliNXhPRkNHVzZqS2F6Q09QcXcrcEtOMnJLUzBkZE5ZR0duVllP?=
 =?utf-8?B?V1ovQTFKZUN0aXJvc2FiYnVhTE92ZXQ5eEkxT1QvcHBxVE1Zdkh6UkZYNDhK?=
 =?utf-8?B?MlN1bnBYZkNHcFd3NjErU0k2Rmw5SThNckNJc1lia05sOTB2cTIzT09nSTdo?=
 =?utf-8?B?dXNQMFBDTG5YMXpYR0RSMDhMYUZSSXpjckgwZmdhU2NDVVNseEptR0hRRDNj?=
 =?utf-8?B?UGhzeGdLSndVWlNkYVIzbjhHZHB0WGVneU5KakxVQVJzMFQ4ckFJZjFYS25s?=
 =?utf-8?B?N0IrZUtCV2hGNS9pQUk3S1R6SkVzdHdiZTJqci9BRFNzQzRBVERocmdLOEc5?=
 =?utf-8?B?T0VwbFlTcTVFaHI3YnlNRXhKKzZ6c09Sc2ZoSE9FS0FqRUw4ZFVPZlo4MUha?=
 =?utf-8?B?alRCQ1F0KythNkxuNWxwNFFZUE92cmVmQTZWMGlGNk8zWXB0aUNDZEFHSjM4?=
 =?utf-8?B?dHpLdG5mYlpSME1ERHZ0eml5T0R3bTJPcm5ja25RMVRrMWhSRGdGa0U1ZnE5?=
 =?utf-8?B?SnZPQjBNYWdCblRWODZkeS9uMDRpVVFoQVluNnZRNyt5MW0rZFVLUG5xUkhR?=
 =?utf-8?B?d3JoQmMrZkV2TXd0KzBsSCtRSUR3YW5HN0VxOFJ2ZFVEVzIyWTdBK2JtVGhn?=
 =?utf-8?B?UisrenpQajYvUUhubCtyd0Qzd0V0N2xaOGVEYjlGZ2NyK1A2WDZKNkQxMGNK?=
 =?utf-8?B?U2FMeXhnQ2w1YUJ2WUVDaTlGeDdvV3pYbitEOG5XWWhCNENtM3BvSzMzdTdK?=
 =?utf-8?B?VnhGbmxLVTU3UzhJODhJZ2p3OEZvMHgxdEhPUHdpdy9qS3JZZnJ3Z2twRTE4?=
 =?utf-8?B?OUQxSEtGK1RLYjNHVlhqL1RDMTd2c2gyRDlrUXhwQWJVWGxkUXYzb1l5b0x4?=
 =?utf-8?B?OG5TMEpTeXFxeUJMQS9WOU1kbmIyd3h6VjE4a0E2TmhVL2wrL1luSDFFckwy?=
 =?utf-8?B?R2tvdDhQSGI5aWhPQVRjVmtTTEQzVnArRUJ3L0RNcStYWFExcXduVFpzaGZ3?=
 =?utf-8?B?ejJSd0RRNDZQRkx6NGNEMHpxendsSUxWc2xuV1lDSllndmNPVEtXK0psRTZ2?=
 =?utf-8?B?NHpDTEVjcEhiVTdzZXh5a2hWWHpSb3FPSEtZNVZ3VHlvVERadk44RjBGbm9h?=
 =?utf-8?B?M1ArVWxEd3gxT0gwamNYY1NjMVhEYldNNGF3MnRNc3NCcDBpZXkrTHFXdEhp?=
 =?utf-8?B?REZNa2lCQ3VuTHJ4dURaSVUzeExzQm5lZGFBTUpmTU8zSjRmNkEveE10Z2x1?=
 =?utf-8?Q?AsR4VxVQ3mHORIa1CM=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: cb7d4515-18bd-411b-6eba-08d9210998f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2021 12:18:55.3517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 375ce1b8-8db1-479b-a12c-06fa9d2a2eaf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8z7dPIxKma//Q8oTYlc4kaVhZzDIomBT1XG/+FosputFIBsjTI2Ur+ViJpJ0llcZgqjHAjITTOJBUSViUey11+wgZWcrEqCaqr4U6JaNctU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2753
X-OriginatorOrg: bruker.com
X-cloud-security-sender: vyacheslav.yurkov@bruker.com
X-cloud-security-recipient: linux-unionfs@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay07-hz2.antispameurope.com with 7FF871A03B40
X-cloud-security-connect: smtp-out.all-for-one.com[91.229.168.76], TLS=1, IP=91.229.168.76
X-cloud-security-Digest: bfa91167f9e9e69dbd91487f89b74a55
X-cloud-security: scantime:1.945
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

SGkgQW1pciwNClRoYW5rcyBmb3IgdGhlIGZvbGxvdy11cC4NCg0KWWVzLCB0aGlzIGlzIGV4aXN0
aW5nIHByb2JsZW0gSSBzb2x2ZWQgd2l0aCBhIHByb3Bvc2VkIHBhdGNoIG9uIG91ciBkZXZpY2Vz
LiBPZiBjb3Vyc2UgaGF2aW5nIGEgcHJvcGVyIHNvbHV0aW9uIHdvdWxkIGJlIGJldHRlci4NClRo
ZSBvbmx5IG9wdGlvbiBJIHNlZSBlbmFibGVkIGluIG15IGNvbmZpZyBpcyBDT05GSUdfT1ZFUkxB
WV9GU19SRURJUkVDVF9BTFdBWVNfRk9MTE9XLg0KDQpUb29rIG1lIHNvbWUgdGltZSB0byBiYWNr
cG9ydCBwcm9wb3NlZCBjaGFuZ2VzIHRvIG15IGtlcm5lbCwgYnV0IHRoZXkgd29ya2VkIGZpbmUu
IFdpbGwgc2VuZCBhIHYyIHNob3J0bHkNCg0KVGhlDQoNCg0KLSBjb25maWRlbnRpYWwgLQ0KDQo+
IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFtaXIgR29sZHN0ZWluIDxhbWly
NzNpbEBnbWFpbC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIE1heSAyNSwgMjAyMSAxMDozMg0KPiBU
bzogWXVya292LCBWeWFjaGVzbGF2IDxWeWFjaGVzbGF2Lll1cmtvdkBicnVrZXIuY29tPg0KPiBD
YzogTWlrbG9zIFN6ZXJlZGkgPG1pa2xvc0BzemVyZWRpLmh1Pjsgb3ZlcmxheWZzIDxsaW51eC0N
Cj4gdW5pb25mc0B2Z2VyLmtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIG92bDog
ZG8gbm90IHNldCBvdmVybGF5Lm9wYXF1ZSBmb3IgbmV3IGRpcmVjdG9yaWVzDQo+IA0KPiAqKkVY
VEVSTkFMIEVNQUlMKioNCj4gDQo+IE9uIE1vbiwgTWF5IDMsIDIwMjEgYXQgOTo0MyBQTSBWeWFj
aGVzbGF2IFl1cmtvdg0KPiA8VnlhY2hlc2xhdi5ZdXJrb3ZAYnJ1a2VyLmNvbT4gd3JvdGU6DQo+
ID4NCj4gPiBUaGlzIG9wdGltaXphdGlvbiBicmVha3MgZXhpc3RpbmcgdXNlIGNhc2Ugd2hlbiBh
IGxvd2VyIGxheWVyIGRpcmVjdG9yeQ0KPiA+IGFwcGVhcnMgYWZ0ZXIgZGlyZWN0b3J5IHdhcyBj
cmVhdGVkIG9uIGEgbWVyZ2VkIGxheWVyLiBJZiBvdmVybGF5Lm9wYXF1ZQ0KPiA+IGlzIGFwcGxp
ZWQsIG5ldyBmaWxlcyBvbiBsb3dlciBsYXllciBhcmUgbm90IHZpc2libGUuDQo+ID4NCj4gPiBD
b25zaWRlciB0aGUgZm9sbG93aW5nIHNjZW5hcmlvOg0KPiA+IC0gL2xvd2VyIGFuZCAvdXBwZXIg
YXJlIG1vdW50ZWQgdG8gL21lcmdlZA0KPiA+IC0gZGlyZWN0b3J5IC9tZXJnZWQvbmV3LWRpciBp
cyBjcmVhdGVkIHdpdGggYSBmaWxlIHRlc3QxDQo+ID4gLSBvdmVybGF5IGlzIHVubW91bnRlZA0K
PiA+IC0gZGlyZWN0b3J5IC9sb3dlci9uZXctZGlyIGlzIGNyZWF0ZWQgd2l0aCBhIGZpbGUgdGVz
dDINCj4gPiAtIG92ZXJsYXkgaXMgbW91bnRlZCBhZ2Fpbg0KPiA+DQo+ID4gSWYgb3BhcXVlIGlz
IGFwcGxpZWQgYnkgZGVmYXVsdCwgZmlsZSB0ZXN0MiBpcyBub3QgZ29pbmcgdG8gYmUgdmlzaWJs
ZQ0KPiA+IHdpdGhvdXQgZXhwbGljaXRseSBjbGVhcmluZyB0aGUgb3ZlcmxheS5vcGFxdWUgYXR0
cmlidXRlDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBWeWFjaGVzbGF2IFl1cmtvdiA8VnlhY2hl
c2xhdi5ZdXJrb3ZAYnJ1a2VyLmNvbT4NCj4gDQo+IEhpIFZ5YWNoZXNsYXYsDQo+IA0KPiBTb3Jy
eSBmb3IgdGhlIGxhdGUgcmVwbHkuDQo+IElzIHRoZSBkZXNjcmliZWQgcmVncmVzc2lvbiByZWFs
bHkgaGFwcGVuaW5nIGluIHJlYWwgZGVwbG95bWVudHM/DQo+IEkgd291bGQgbGlrZSB0byBhdm9p
ZCByZW1vdmluZyB0aGUgb3B0aW1pemF0aW9uIGlmIHBvc3NpYmxlLg0KPiANCj4gSW4gYW55IGNh
c2UsIGlmIHdlIGhhdmUgdG8gc3VwcG9ydCBleGlzdGluZyBkZXBsb3ltZW50cyB0aGF0IHVzZSB0
aGlzDQo+IHByYWN0aWNlLA0KPiB0aGUgb3B0aW1pemF0aW9uIHNob3VsZCBiZSByZW1vdmVkIG9u
bHkgZm9yIHRoZSBjYXNlIHdoZXJlIHRoZSB1c2VyIGRpZCBub3QNCj4gb3B0LWluIHRvIGFueSBv
ZiB0aGUgbmV3IGZlYXR1cmVzLCBxdW90aW5nIG92ZXJsYXlmcy5yc3Q6DQo+ICcNCj4gICBPZmZs
aW5lIGNoYW5nZXMgdG8gdGhlIGxvd2VyIHRyZWUgYXJlIG9ubHkgYWxsb3dlZCBpZiB0aGUNCj4g
ICAibWV0YWRhdGEgb25seSBjb3B5IHVwIiwgImlub2RlIGluZGV4IiwgInhpbm8iIGFuZCAicmVk
aXJlY3RfZGlyIiBmZWF0dXJlcw0KPiAgIGhhdmUgbm90IGJlZW4gdXNlZC4gSWYgdGhlIGxvd2Vy
IHRyZWUgaXMgbW9kaWZpZWQgYW5kIGFueSBvZiB0aGVzZQ0KPiAgIGZlYXR1cmVzIGhhcyBiZWVu
IHVzZWQsIHRoZSBiZWhhdmlvciBvZiB0aGUgb3ZlcmxheSBpcyB1bmRlZmluZWQsDQo+ICAgdGhv
dWdoIGl0IHdpbGwgbm90IHJlc3VsdCBpbiBhIGNyYXNoIG9yIGRlYWRsb2NrLg0KPiAnDQo+IA0K
PiBUaGlzIG1lYW5zIHB1dHRpbmcgdGhpcyBjaGVjayBmcm9tIG92bF9sb3dlcl91dWlkX29rKCkg
aW50byBhIGhlbHBlcjoNCj4gDQo+IHN0YXRpYyBpbmxpbmUgYm9vbCBvdmxfYWxsb3dfb2ZmbGlu
ZV9jaGFuZ2VzKHN0cnVjdCBvdmxfZnMgKm9mcykNCj4gew0KPiAgICAgICAgIC8qDQo+ICAgICAg
ICAgICogVG8gYXZvaWQgcmVncmVzc2lvbnMgaW4gZXhpc3Rpbmcgc2V0dXBzIHdpdGggb3Zlcmxh
eSBsb3dlciBvZmZsaW5lDQo+ICAgICAgICAgICogY2hhbmdlcywgd2UgYWxsb3cgbG93ZXIgY2hh
bmdlcyBvbmx5IGlmIG5vbmUgb2YgdGhlIG5ldyBmZWF0dXJlcw0KPiAgICAgICAgICAqIGFyZSB1
c2VkLg0KPiAgICAgICAgICAqLw0KPiAgICAgICAgIHJldHVybiAoIW9mcy0+Y29uZmlnLmluZGV4
ICYmICFvZnMtPmNvbmZpZy5tZXRhY29weSAmJg0KPiAgICAgICAgICAgICAgICAgICAgICFvZnM+
Y29uZmlnLnJlZGlyZWN0X2RpciAmJiBvZnMtPmNvbmZpZy54aW5vICE9DQo+IE9WTF9YSU5PX09O
KTsNCj4gfQ0KPiANCj4gTm90ZSB0aGF0IG92bF9sb3dlcl91dWlkX29rKCkgZG9lcyBub3QgY3Vy
cmVudGx5IGNoZWNrIHRoZSByZWRpcmVjdF9kaXINCj4gZmVhdHVyZSwgYnV0IGl0IHdvdWxkIGJl
IGJldHRlciB0byB1c2UgdGhlIHNhbWUgaGVscGVyIGluIHRoYXQgY2FzZSBhcyB3ZWxsLg0KPiAN
Cj4gVGhhbmtzLA0KPiBBbWlyLg0KPiANCj4gPiAtLS0NCj4gPiAgZnMvb3ZlcmxheWZzL2Rpci5j
IHwgNSAtLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNSBkZWxldGlvbnMoLSkNCj4gPg0KPiA+
IGRpZmYgLS1naXQgYS9mcy9vdmVybGF5ZnMvZGlyLmMgYi9mcy9vdmVybGF5ZnMvZGlyLmMNCj4g
PiBpbmRleCA5M2VmZTcwNDhhNzcuLmY2NmY5NmRkOWYwYyAxMDA2NDQNCj4gPiAtLS0gYS9mcy9v
dmVybGF5ZnMvZGlyLmMNCj4gPiArKysgYi9mcy9vdmVybGF5ZnMvZGlyLmMNCj4gPiBAQCAtMzM4
LDExICszMzgsNiBAQCBzdGF0aWMgaW50IG92bF9jcmVhdGVfdXBwZXIoc3RydWN0IGRlbnRyeSAq
ZGVudHJ5LA0KPiBzdHJ1Y3QgaW5vZGUgKmlub2RlLA0KPiA+ICAgICAgICAgaWYgKElTX0VSUihu
ZXdkZW50cnkpKQ0KPiA+ICAgICAgICAgICAgICAgICBnb3RvIG91dF91bmxvY2s7DQo+ID4NCj4g
PiAtICAgICAgIGlmIChvdmxfdHlwZV9tZXJnZShkZW50cnktPmRfcGFyZW50KSAmJiBkX2lzX2Rp
cihuZXdkZW50cnkpKSB7DQo+ID4gLSAgICAgICAgICAgICAgIC8qIFNldHRpbmcgb3BhcXVlIGhl
cmUgaXMganVzdCBhbiBvcHRpbWl6YXRpb24sIGFsbG93IHRvIGZhaWwgKi8NCj4gPiAtICAgICAg
ICAgICAgICAgb3ZsX3NldF9vcGFxdWUoZGVudHJ5LCBuZXdkZW50cnkpOw0KPiA+IC0gICAgICAg
fQ0KPiA+IC0NCj4gPiAgICAgICAgIGVyciA9IG92bF9pbnN0YW50aWF0ZShkZW50cnksIGlub2Rl
LCBuZXdkZW50cnksICEhYXR0ci0+aGFyZGxpbmspOw0KPiA+ICAgICAgICAgaWYgKGVycikNCj4g
PiAgICAgICAgICAgICAgICAgZ290byBvdXRfY2xlYW51cDsNCj4gPiAtLQ0KPiA+IDIuMjUuMQ0K
PiA+
