Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CEC6C4332F
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 Oct 2023 16:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbjJ3QkT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 30 Oct 2023 12:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbjJ3QkS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Oct 2023 12:40:18 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2091.outbound.protection.outlook.com [40.107.93.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C88A9B
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 09:40:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQnWTvnEF5mp5WxdnyzlMsqGPBHAxeOTYlAy9sRVs+iHl37eQyhnfSX3uiIF1LUeQTZ3xracB4NdtKYnHtLrGh+4y6NA5fPXN4CCxT+WV7PTcsy9/fTuxIPYgQTE8ppRBYiKSpzGPS/pVA7FQ1trgm0UgPZXgk3vTBYh/h50MS4/YmmF2Ha8S8YmztjkYZqKaFtuEaezlZ2KnJ16pQjFmfXuP3J3UZI5luWK8kQBtFfzPksh5fau8Q7q7fxHXzOOiSdHjzW5rOSauweRzf8TPBQTL3QdDgAddLsElbPnMnZzzhrJ4bRG5D7utejrljJjFSgq/9DmMOUTbdJyC4CmKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fD5B79SK2vM7QrxZN66WpwJLmmRrjtTHFEBH8SjcsCU=;
 b=K1GK8gbapINa7hdy33bz1XcEWxA6fx3j/S17HHv7X3tnwMNpLm0jLQVlh+v89l9p4hTMoSM9jVARijFinDcD4jqMSUMsN7m+VaWHgy4szoy2Ua0X29XicH10599HAONdaHiCva9remcsLNldbmbiECj7UHgMj2QWzM7e7qp599KCWGuSNn6Q48eevPguJR/G4TClfiX6EeTusWTO0iKi4Ouhtj92oDIIm+92bfG9ZEV4h8EivyNIPDN8WEvRa6k9QN3Vg+gaAHwNGL5uS7QOA6hEXkT/URZhWDxO0FloQPW78hT0N0JHsk+gIM2CUpo3vsEcSrGZJt6TTrWTS3fgug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=obsidian.systems; dmarc=pass action=none
 header.from=obsidian.systems; dkim=pass header.d=obsidian.systems; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=obsidiansystems.onmicrosoft.com;
 s=selector1-obsidiansystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fD5B79SK2vM7QrxZN66WpwJLmmRrjtTHFEBH8SjcsCU=;
 b=Nwx/XJviuRo5lM2uITxfzWnMFh3xnbKpcCUiH26J5AjVPVuddfH3mth+kx/T4OCTfTWcj/dI+VK+e+/MHsevofBCXXhrofaydOWXmezsTgu/1oFE1aOp9uM6QWCpWjqAII5s6HeNTaWP5lvoz7PFlFbHIMfGT6asC5ZFJ6ymKg8=
Received: from PH7PR14MB5569.namprd14.prod.outlook.com (2603:10b6:510:1fb::16)
 by PH0PR14MB4590.namprd14.prod.outlook.com (2603:10b6:510:9b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28; Mon, 30 Oct
 2023 16:40:09 +0000
Received: from PH7PR14MB5569.namprd14.prod.outlook.com
 ([fe80::f021:1e3d:f24:eaf8]) by PH7PR14MB5569.namprd14.prod.outlook.com
 ([fe80::f021:1e3d:f24:eaf8%5]) with mapi id 15.20.6933.026; Mon, 30 Oct 2023
 16:40:08 +0000
From:   John Ericson <john.ericson@obsidian.systems>
To:     Amir Goldstein <amir73il@gmail.com>
CC:     "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: "Resetting" an overlay fs entry; clearing the upper layer and
 revealing the lower layer
Thread-Topic: "Resetting" an overlay fs entry; clearing the upper layer and
 revealing the lower layer
Thread-Index: AQHZuPyPVjqAOjROjky9Pum6cGQnI6/C2p7JgJ8xGIqAAHNGgIAAq10o
Date:   Mon, 30 Oct 2023 16:40:08 +0000
Message-ID: <PH7PR14MB556931977A940FC17484CCD0F5A1A@PH7PR14MB5569.namprd14.prod.outlook.com>
References: <PH7PR14MB55699F84995FB1FBBEA5663BF53BA@PH7PR14MB5569.namprd14.prod.outlook.com>
 <PH7PR14MB55698C0C851B995C9E8C649AF53EA@PH7PR14MB5569.namprd14.prod.outlook.com>
 <PH7PR14MB5569AA53E80797E88333DA5FF5A1A@PH7PR14MB5569.namprd14.prod.outlook.com>
 <CAOQ4uxjUzQeTbPEyUBZK8DyBQQg9cEznroq2abMVJDEK+5dz3Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxjUzQeTbPEyUBZK8DyBQQg9cEznroq2abMVJDEK+5dz3Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=obsidian.systems;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR14MB5569:EE_|PH0PR14MB4590:EE_
x-ms-office365-filtering-correlation-id: b0ecf293-f665-4b1a-ae56-08dbd966e0f8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +HE2qBcIBJg4Yh317f/cohVjdfaBcFyERZB8gtGN7Q+tPEW5vSa6AWJvit5iWR9BlX9Ki4iUuVEhTgu3ukCjJCY4i+MXd8KWp5BRYi/XobfinXLBAK6GVpk63IyUyL4Hj2zM5pOF10FT4VMTED/wo46GcUyfzIO41Mp1Qcj+0VbauPDl0diA92aGsEVhXvEU8c8S3FdOX9wNgg9upMRrBtylwFJZkPi2ZwXB6mxUVEYYR4KtiNnBwfgBdBeoImnkLmWse3jPRyTPPF5bnBd2lo9dK3v+5rHKD+Y1gZ98v2Dn3F2v03b4qE34vIlhyEpqaAZuODcVqL/+VKEm+Bv/bnk/EgcQfGbUdLctrqU7Nib3TAP7x/MC6Uyi5lC1v/2s3/tzcvAkzipdlSH4DydkrjsRihgR6yH7hWinX8tcU1ZHRl6S/IX7SyAauVsyG6AScV57uadM2ic0jjZqixM8jamnGhD6Wq/aYVjq04TTh6YrIM55qhBExxZ+WrNOq6IyIDUoSolinV3IB7MCFTbGuUfFPsiQy3/be4/T6LE1Q6BwCNm/EHjlStjeSvdSgiV7B1ayylKsgQp8qBTCvF+yoKPVaBzMDwdyUjQS9tCNVW8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR14MB5569.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(376002)(396003)(136003)(39830400003)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(41300700001)(6506007)(7696005)(53546011)(71200400001)(9686003)(966005)(478600001)(83380400001)(26005)(2906002)(5660300002)(6916009)(64756008)(66476007)(66946007)(66556008)(54906003)(66446008)(76116006)(91956017)(52536014)(38070700009)(44832011)(4326008)(8676002)(8936002)(316002)(86362001)(33656002)(38100700002)(122000001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHVETXdXUE9hVTlMYVVLS1dQcFFzQTJCUjExM1hOODlRRXg4UEMrMk9RODRF?=
 =?utf-8?B?VDU1UUc5d2svMzkwU2ZPSWNxWGZIME84V0NJVmZxb1FKc0UvQ0VlOWExbHo3?=
 =?utf-8?B?OG4zM2hjU3F0b01FeDk5bUZLUmFiYUdTNjcwcm9NaWNMWENJeTdxanpVV1Rx?=
 =?utf-8?B?K2NnMFVhV0dkKzdUUFhzVTB4d3VDL05pVHhpNE05VXJ5WW8zeG9XaGNCSFhT?=
 =?utf-8?B?K2dBTldyczl3M3VBUG1PSUx3L0xpaEQ0M0x2Z0p4MFV3blJFRUJsVUVlb3du?=
 =?utf-8?B?NGNzY0ZOdFI1eTdTWXI4amJOUk95THozNFdSd1ZEaDZseExwYnEzajRGQ2Ew?=
 =?utf-8?B?djg5TFg1RWZCWEZ0amc3WkdNeWhHNnN3R0piMVFCNnMrcUZvampJdGwwTXdN?=
 =?utf-8?B?ZXBOSllCUVJ0OUVQa2lmL3lFVmhwNnFNbUUzamRWcUlkWVpMN1MrMVVscitn?=
 =?utf-8?B?TGJpbTU2bzlxL29jSGp0U1RVRkpyOTNjeXRsTGtBUmVYZXZkWjFiWkN6eEMw?=
 =?utf-8?B?S0hBRW1ZSVpnSTJJYzZsS3FLUnBoTTdYb0tETkRnekFyV1p5ZlZ1SG1GeUFr?=
 =?utf-8?B?V0NCWm16dmR6K0NkVHpHMGhiakl4NGNQNFRIeFNmWjlRNnl3QUtSdGZrRWRX?=
 =?utf-8?B?UDdlaGZpNkpUUUMrZER1SzZSRzRkbGdjQ1ZxK2JTMUp3NndFMVJNak9wQTVr?=
 =?utf-8?B?Snh5KzM4OXd1VXBlSnI3Qm1zUU81a2kxUXpFMjBpN09GZmorajFxTzJ3Nzdn?=
 =?utf-8?B?aUovUURwQzliWERmajB2T29oaWVBVDdsd2VIekxlOFBYL0JlSEhaS1ZmOS9a?=
 =?utf-8?B?eU9XcUFyMmo0WS8yVFppVE9hdUtxc1RvKzMvOTErUFBQTHpRdXpQTWVDOTdG?=
 =?utf-8?B?RTJtd1ZoNmEvUWErV1NESGVlMUpkeWVmcW1WMUZLRisrdzgzMVFsZUxMZHVu?=
 =?utf-8?B?TCtvQjUwTEtlMFY2MWV6YWtYdHZsTzB0eEpvc3J4cDFxZy9XL3RCTXk2dlVD?=
 =?utf-8?B?YnlBNkhHUEE4ajlFQkFncFBIdUpNWE1DcTlKaktpbEZ3QkhFNU5CaFM4ZUR5?=
 =?utf-8?B?RGFPUVcrTnpBRHBwUzQ5bndNWG4zNUk2S0JEYkFzeHB3NDZkT1k2aXNleUZC?=
 =?utf-8?B?M2dXV0p5cXAyV0xpVm1oejdjOUlQOGhCdFZGeUttUnhlbWFWSkhkYUJnZkpr?=
 =?utf-8?B?T21CRVN4TFZOa0MzU3VlZlgwL0lXWHFvRThXUVl3amJMdmFWVFlKK0wvK3ZO?=
 =?utf-8?B?V1RTK2VEeVFwaVJLdnlpYzZiWmJ4bWw0enNxY1F2WjVpNnJsc01uU1ltckM3?=
 =?utf-8?B?RmtKK2lQODFHTlFtMmdsaVRyTmlJaGFqVHNRcW4zWkpxYUMzd3BEMGFrOVk1?=
 =?utf-8?B?TE5ZZVRoUlJXbXIwU1pMcTRpSG1YSHFPVi9Fb3l3aFNVeEZmaU9OY3JDeEtl?=
 =?utf-8?B?VTgzUlJ1VnJMZ0ZjZEM4OTZDUHNEQ2haL2JGQVVZZGJxT2JtL29YNnZYU0VY?=
 =?utf-8?B?MnBRUExJSGxKWHhObnRsRUlLMXQ4WDAxQlNxUTFZcDh0S3pwNktHbzZmaDg4?=
 =?utf-8?B?cm5RN2gvQ2tHVUwxREsyWkdnbFlaemU5TUpvcDIyRmsyaFdlTHFXdWN0ckg2?=
 =?utf-8?B?SGdmUXh0Yzc3dXJrdUxyZ2ZzcUZTSEUycDhxcisvVFFERjQ5b0pIam5acTRW?=
 =?utf-8?B?WGZaSjhZdmxmdWJKK2QycnNvVFpZdXlpNzRQSU0yNlRBdWlvM09PaXlhMk0r?=
 =?utf-8?B?MG1jcGpXY2gyK0NnZE1GNnFGcStiaFZhdXRyMnhnUmtsYWlnN2dUbDJiZmJx?=
 =?utf-8?B?VXhNS0dXVERmd253VjBxa2JqT1ZxTmVySFBqS1UrOTRWL0tZSmlOQXZCUGlu?=
 =?utf-8?B?K2M1MGtmeVpQcWJnZm96d1JNcUtHaEdXejdYRGdiWEFOcUNRa1dRZ2xZcFpF?=
 =?utf-8?B?UWRIbDVURlFMYjRSU3FGNnczV0pxbi9jc2E3d1dKSHFBdVRzQkw5T0xkNzNs?=
 =?utf-8?B?OW5zemxydDZwUE1TMndSOG14MFJRZ0VQR09USW1CdnlaRWNJTm4vMDU5Z2VY?=
 =?utf-8?B?S2RydmpVL3BaRFNwa0tqYVhubzZOc0pPK2J6aFo4bG96eVd2ZWhCeDcwdGJ6?=
 =?utf-8?B?OUlYcFdZbVo0MGVBc0plaGhwbjdWVEVqd2hRbjUwTWlKeTBuSDhzQmNHRWdz?=
 =?utf-8?B?eWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: obsidian.systems
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR14MB5569.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ecf293-f665-4b1a-ae56-08dbd966e0f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2023 16:40:08.6847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9e4fbd9c-5fe9-457b-906b-5ad50664f878
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZXItQ9fYBUK+oKZu3lbrBY5qJG9TIy1Ha1/ddfPQWmI94gLFYJjK+haeAT2ZMoLScJm/0IB1Z70/7efTVHVG2bjyLl2iPfT9OcFZJo342w0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR14MB4590
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

T24gMTAvMzAvMjMgMDI6MTUsIEFtaXIgR29sZHN0ZWluIHdyb3RlOgoKPiBPbiBNb24sIE9jdCAz
MCwgMjAyMyBhdCA2OjE24oCvQU0gSm9obiBFcmljc29uCj4gPGpvaG4uZXJpY3NvbkBvYnNpZGlh
bi5zeXN0ZW1zPiB3cm90ZToKPiAKPj4gV2UgYXJlbid0IHdvcmtpbmcgb24gdGhpcyBhdCB0aGUg
bW9tZW50LCBidXQgSSBkaWQgaGF2ZSBzb21lIG9mZi1saXN0IGRpc2N1c3MgZGlzY3Vzc2lvbiB3
aXRoIEFtaXIgR29sZHN0ZWluLiBJIHdhbnRlZCB0byBpbmNsdWRlIG91ciBjb3JyZXNwb25kZW5j
ZSBvbiB0aGlzIGxpc3QgZm9yIHBvc3Rlcml0eSAtLS0gZS5nLiB1cyB3b3JraW5nIG9uIHRoaXMg
bGF0ZXIsIHNvbWVvbmUgZWxzZSB3b3JraW5nIG9uIHRoaXMgbGF0ZXIsIGV0Yy4sIGFuZCBoZSBz
YWlkIHRoYXQgaXMgZmluZSwgc28gaGVyZSBpdCBpcy4gSXQgdG9vayBtZSBhIHdoaWxlIHRvIGZp
bmQgdGhlIHRpbWUgc3BsaWNlIHRvZ2V0aGVyIGFsbCB0aGUgcmVwbGllcyBhbmQgdGhlaXIgcXVv
dGVzLCBidXQgbm93IEkgaGF2ZSBpdC4KPj4gCj4+IAo+IFRoYW5rcyBmb3IgdGhlIGZvbGxvdyB1
cC4KClN1cmUgdGhpbmcuIEl0IHdhcyBsaW5nZXJpbmcgb24gbXkgVE9ETyBsaXN0IGZvciB0b28g
bG9uZy4gR2V0dGluZyBpdCBkb25lIGZlZWxzIG11Y2ggYmV0dGVyLgoKPj4gT25lIHRoaW5nIEkn
bGwgYWRkIGlzIHRoYXQgd2hpbGUgSSBzdGlsbCB0aGluayB0aGlzICJyZXNldHRpbmciIG9wZXJh
dGlvbiBpcyBhIGdvb2QgZmVhdHVyZSBmb3Igb3ZlcmxheSBmcyBpbiBnZW5lcmFsIChhbmQgbm90
IGp1c3Qgb3VyIHVzZS1jYXNlKSwgdGhlIEZVU0UgcGFzc3Rocm91Z2ggd29yayAoZnJvbSBBbmRy
b2lkIG1vc3QgcmVjZW50bHksIG5vdCB5ZXQgbWVyZ2VkIEFGSUFLKSB3b3VsZCBiZSBhbiBldmVu
IGJldHRlciBmaXQgZm9yIG91ciB1c2UtY2FzZSB0aGFuIG92ZXJsYXkgZnMuIEkgZG9uJ3Qga25v
dyBpZiB1cHN0cmVhbWluZyB0aGF0IGlzIHN0aWxsIGJlaW5nIHB1cnN1ZWQsIGJ1dCBpZiBpdCBp
cywgaXQgc2VhbXMgcmVhc29uYWJsZSB0byBqdXN0IHdhaXQgZm9yIGl0Lgo+PiAKPiB2MTQganVz
dCBwb3N0ZWQgMiB3ZWVrcyBhZ286Cj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtZnNk
ZXZlbC8yMDIzMTAxNjE2MDkwMi4yMzE2OTg2LTEtYW1pcjczaWxAZ21haWwuY29tLwo+IAo+IC0g
QWxsIGlzc3VlcyB0aGF0IE1pa2xvcyBtZW50aW9uZWQgYXMgbXVzdCBmb3IgZmlyc3QgcmVsZWFz
ZSBoYXZlIGJlZW4gYWRkcmVzc2VkCj4gLSBPbmx5IHhmc3Rlc3RzIHJlZ3Jlc3Npb25zIGFyZSBk
dWUgdG8gbm8gaW52YWxpZGF0ZSBvZiBhdHRyaWJ1dGUKPiBjYWNoZSBvbiBtbWFwIHdyaXRlcwo+
IAo+IEkgZG9uJ3Qga25vdyBvZiBhbnl0aGluZyB0aGF0IHNob3VsZCBiZSBibG9ja2luZyB0aGlz
IHdvcmsgZnJvbSBiZWluZwo+IG1lcmdlZCB0byB2Ni44LCBidXQgaXQgZG9lcyBub3QgbWVhbiB0
aGF0IGl0IHdpbGwgYmUgbWVyZ2VkIDspCgpPaCBncmVhdCEgSSB2ZXJ5IG11Y2ggZmFpbGVkIHRv
IGdvb2dsZSB0aGF0LCBvbmx5IHNlZWluZyB0aGUgMjAyMSB0aHJlYWQuCgo+PiBJbmRlZWQsIEZV
U0UgcGFzc3Rocm91Z2ggb3VnaHQgdG8gYmUgYSBnb29kIHJlcGxhY2VtZW50IGZvciB0aGUgd2hv
bGUgZ2FtdXQgb2YgZXhvdGljIGJpbmQvdW5pb24vb3ZlcmxheSBtb3VudGluZyB3aXRob3V0IG91
dCBhZGRpbmcgZW5kbGVzcyBtb3JlIGZ1bmN0aW9uYWxpdHkgYW5kIGNvZGUgdG8gdGhlIGtlcm5l
bC4KPj4gCj4gSWYgeW91IGFyZSBleHBlY3RpbmcgdGhhdCBGVVNFIHBhc3N0aG91Z2ggd2lsbCBt
YWtlIG92ZXJsYXlmcyByZWR1bmRhbnQKPiB5b3UgaGF2ZSB2ZXJ5IGhpZ2ggZXhwZWN0YXRpb25z
IGZyb20gRlVTRSBwYXNzdGhyb3VnaC4KPiAKPiBGaXJzdCBvZiBhbGwsIHRoZSB3b3JrIHRoYXQg
d2FzIHByb3Bvc2VkIGZvciB1cHN0cmVhbSBpcyBvbmx5IGZvciBGVVNFIGZpbGUgaW8KPiBwYXNz
dGhyb3VnaCwgd2hpY2ggbWVhbnMgdGhhdCBhbnkgbm9uIGlvIG9wZXJhdGlvbiBzdGlsbCBoYXMg
YSBzaWduaWZpY2FudAo+IHBlcmZvcm1hbmNlIG92ZXJoZWFkIHdpdGggRlVTRSBjb21wYXJlZCB0
byBvdmVybGF5ZnMuCj4gCj4gVGhlIHBsYW4gb2YgRlVTRSBCUEYsIHRoYXQgd2FzIHByZXNlbnRl
ZCBieSBBbmRyb2lkIHRlYW0gaGFzIHRoZQo+IHBvdGVudGlhbCB0byBicmluZyBGVVNFIHBhc3N0
aHJvdWdoIHBlcmZvcm1hbmNlIG11Y2ggY2xvc2VyIHRvIG92ZXJsYXlmcwo+IGJ1dCB0aGF0IGlz
IHN0aWxsIGEgbG9uZyB3YXkgdG8gZ28uCgpZZWFoIHRoYXQgbWFrZXMgc2Vuc2UuCgpJIGFtIG5v
dCBzdXJlIGV4YWN0bHkgd2hhdCB0aGUgYm91bmRhcnkgaXMgYmV0d2VlbiBJTyBhbmQgbm9uLUlP
IG1vZGlmaWNhdGlvbnMsIGJ1dCBJIHN1c3BlY3Qgd2UgY291bGQgbHVjayBvdXQgdGhlcmUuCgoo
V2UnZCBiZSBwdXR0aW5nIHRvZ2V0aGVyIGEgc2luZ2xlICJ2aXJ0dWFsIiBkaXJlY3Rvcnkgd2hv
c2UgY2hpbGRyZW4gYXJlIGFsbAotICJyZWFsIgotIHRha2VuIGVudGlyZWx5IGZyb20ganVzdCBv
bmUgb3IgdGhlIG90aGVyIHVuZGVybHlpbmcgImxheWVycyIgYW5kIG5vdCBtZXJnZWQgZnJvbSBi
b3RoCi0gcmVhZC1vbmx5LCBhcyBhbiBhZGRlZCBib251cwopCgpJIG1lYW50IGxlc3MgdGhhdCBJ
IGV4cGVjdCBwaGVub21lbmFsIHBlcmZvcm1hbmNlIGluIDYuOCBmb3IgYXJiaXRyYXJ5IGZvcm1l
ciBvdmVybGF5ZnMgdXNhZ2UgOiksIHRoYW4gdGhhdCBpdCdzIG5pY2UgdG8gYmUgIm9uIHRoZSBy
aWdodCB0cmFjayIgd2l0aCB0aGUgcmlnaHQgc29ydCBvZiBhcmNoaXRlY3R1cmUgZm9yIGJvdGgg
cGVyZm9ybWFuY2UgYW5kIGV4cHJlc3NpdmVuZXNzIGV2ZW50dWFsbHkgOikuIEdvb2QgbHVjayEK
ClRoYW5rcywKCkpvaG4=
