Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CAC8C04A68
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Jul 2022 01:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbiG1Bu1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 21:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbiG1BuY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 Jul 2022 21:50:24 -0400
Received: from esa7.fujitsucc.c3s2.iphmx.com (esa7.fujitsucc.c3s2.iphmx.com [68.232.159.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB754D821
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Jul 2022 18:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1658973023; x=1690509023;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HQPsCXFJgEdwQvc/OAVYCxAiKOk6OIjg2cg8PYvaxaE=;
  b=SxMV4yrEg0ZF7+WP4OlQLh+FJyFELbCLwVdPAXcImudlfePhkDciBi4e
   30E6lbe4gDIVxW3Hbm1OdtMN1pDY2BKZ8j2Q00Zzv7vUOXxZL38fjP6pK
   RLbVOocOBeiliVhmq/jlYWi4q1M6EE4jo7iBMA3befC5I448+GpHvQL+P
   4eq9nxkJLQ1pOmWam/rghVJ6zkxfJGaYMBZ6IY1vChYhTTWIgG/3KfVjw
   lMbr8mcUhOfPmBqyOwhEG0vIqAdPk1UcrDS7zdmhBry+BKXMfEInHABnQ
   HrXtHWQKY8V+mp0DRFwf03ZxZLJWnr/JCfZnsLeiw3C4hd9r/9mfgPnR7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="61529091"
X-IronPort-AV: E=Sophos;i="5.93,196,1654527600"; 
   d="scan'208";a="61529091"
Received: from mail-tycjpn01lp2177.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.177])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 10:50:20 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFFMQhSOGCn4pwrDeUBeQ+kOr0SlA0zF3j/pkvJR1Brpk3uW6+8CnEkg76SkqRd8JbUkvHDMm2BbkjBJPzjrBQBD2ncLfbDjIkZoaM8WXFQ4pJL2HfrpGm3Dz6IGeU49St7v99Yi88DZY/j/Wul785uA9ILelHhbjmbPdaqaANLTMazmR9E/krNUicJuTlyFUXfIukCY9/Qs1H3b0BiN00xLXSj3DRga0uscmOwYPnPw1UTa+AqQbqugFKX3GpykFDeGgw2DoAV7EMM0RsiJi8oF0mncE3c/fWUHGt+SPk10+tVSMmgBSET9S57vjnq7Kf+oMigerAWxnqJfWpHxBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQPsCXFJgEdwQvc/OAVYCxAiKOk6OIjg2cg8PYvaxaE=;
 b=ASL2xINRCzO7mTEvXMIryvdgofW6KuK3uSAunWr3XFFME0OTxW5YIsLs/8DOUEXUsiCOgAM8clpuSGb/s8Ab9DiDmTyI/TuLZ6ZtCqgQ3qUgFlmFqugbTeXhN+gYFuHSQ63KjFUPA7UQ6oVlr6LYFMHopAU3WfOFzKK4KMAuSIED2+KUXSLLTwWlrAm8KcyPCGbP/3lEUXbD1d18TIDO3idv/1VAe2WZ0MjtA2Jr/jw4vyLUWh5TfhkUjwSVn6ovlhB0Uk3HHajTdVB/DzNPJeXFOCOsZxw6ZS6TRkAvlM74OPuzFEdFBKBJvAde4vNYMXEVd9kOrlhxo8AlGqHDBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OSAPR01MB4419.jpnprd01.prod.outlook.com (2603:1096:604:62::18)
 by OSBPR01MB3575.jpnprd01.prod.outlook.com (2603:1096:604:43::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.10; Thu, 28 Jul
 2022 01:50:17 +0000
Received: from OSAPR01MB4419.jpnprd01.prod.outlook.com
 ([fe80::dd62:e735:6d22:61fc]) by OSAPR01MB4419.jpnprd01.prod.outlook.com
 ([fe80::dd62:e735:6d22:61fc%6]) with mapi id 15.20.5482.006; Thu, 28 Jul 2022
 01:50:16 +0000
From:   "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
CC:     overlayfs <linux-unionfs@vger.kernel.org>,
        Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] overlayfs: improve ovl_get_acl
Thread-Topic: [PATCH] overlayfs: improve ovl_get_acl
Thread-Index: AQHYmDKR4j6SoiHMykehjgIWfUfDc62SSpWAgADeyQA=
Date:   Thu, 28 Jul 2022 01:50:16 +0000
Message-ID: <1b327b79-fb00-2433-63e2-1fb4428537f8@fujitsu.com>
References: <1657883207-2159-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <CAJfpeguPSWqy+O2jrTV6mKwXEaKefR33cwOJJ=4wDbiu32Eiqg@mail.gmail.com>
In-Reply-To: <CAJfpeguPSWqy+O2jrTV6mKwXEaKefR33cwOJJ=4wDbiu32Eiqg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c30ae08-4942-4bf2-1a36-08da703b8542
x-ms-traffictypediagnostic: OSBPR01MB3575:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qw/Aaz3NpgQrrd1QBAH2OzdmLHRGb0Q6h4zN1Tlxeb7sdT0SRAQzsLs2k8jBbAQxF2koiPV1Ugs37RYrim/+HkIT3VfOIdlle+Hd82GvM332+XY79w0VNL0oShlmtvjsMXqD0IDR6WV/Zu0eeeyVkuYzBugOdq9OFs0IXejFbF2rUZW+9QO6RsitmQ7/DComKcvbuospAQC+45vhQP7M6KIPpIYbXRwW2Ee+6oYcoMF9TVK1ba3pQ2MnCReKIKSHHpvf5mjlryAAClb2+fxT3kMUyLVz7r4S6r35xDarnVLp5wjSEJjpPkkWN48Q0B1fcNUJ+83LWp98y2z0XpD/rhw2wy3lJy2uFWnjUvC9LLonmulUAwvV7xGhyduMpvbVudycKC6yTrQvNvOMUk6fwRN9/3OLQKFWT5yY2nZrP7RzfzfySjrETJpKYOyQX3ea7dHk5omnPfhDB9LfzvCm+fgezTCVcQ/yu01kbhIsG6lujpGF0V5J2dwaCmxxrJRxpznA43fh1Yv1spY6g6KKiKb3DENcMk2efTSguLSXEtw6r1Rttqma3FhXOIJ5nDMnlL63k2WpACp1Flwd1aGYR3f9z36ZmNMY5MTHE1dovCOAU9jGD5+Rbf2F6ahKja1urj1OHHXTpuHWfMp5hVCrIuYeE1gALzorihYpZtBCFJzxCFccVixwBfqCyXQFuuSsL2mzkik9F9KpsCy2nnyb5CreikxaQG4U274kiv/BNYtEyMUpg1tX3TbJutEWH6PnHL7BPs1v+AwWH2s1lOLP8sbouD4bf8UbtI5vMvdUQkLin6r+ef1ZmWGk/PSCn0FWg8XLx/Ud8a2P6S5Aro849Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB4419.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(82960400001)(6916009)(54906003)(38070700005)(36756003)(316002)(122000001)(31686004)(91956017)(8676002)(76116006)(66476007)(66556008)(4326008)(64756008)(66946007)(38100700002)(85182001)(66446008)(6486002)(2906002)(6506007)(71200400001)(26005)(6512007)(41300700001)(31696002)(5660300002)(83380400001)(86362001)(2616005)(478600001)(186003)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clI3LzBqRlBybzBiODFXUVlNeWdZTVZiWVYrc0RLZjBVWFRiZlJvNDA1Wk5w?=
 =?utf-8?B?MUNMWVJqWHIvY2RCRlVidlU3TForQ0dQMldjSVZKVDZIZGt3dytEdVcxdUV4?=
 =?utf-8?B?TllFbGRXcEpxZzE4cTJKWTFKd2tEMlAzUjJvMndZSmtmcndHOEpRbkVrbUt6?=
 =?utf-8?B?dXZxaUd1Z1BqOUhqNFB3eFh0RG1BWUc4djhWMStzSXlMRkpyK3NjKzBuMUxu?=
 =?utf-8?B?MGFWZFZOQXUvRkkvOWRwUktuclNlbjB4WmlLZThrbHhzSjFqNExiRlJ1dU9i?=
 =?utf-8?B?VG9zUzA4N0dZT1Rpa1R3enNxWG1Fd0x0K3d1RVhVdGc4cGJZalZWNndmcXBt?=
 =?utf-8?B?dHNwdElPTEhLejA5VVpKbGlBa0t6WGUwY0t5NnlGUkZONFVhbHZKTllUMlh4?=
 =?utf-8?B?Zkloa3QxTGpFS3d2N3ZQd1RLWGNSSHhkMkpyMmVrd0tUMnBRL3R5VFBhUDNM?=
 =?utf-8?B?Tnl4anR3U1A5OUl3dlJLWXFvOUljNjBVVjhSb0tkWW4wZkZEVzRQZVhwU2NQ?=
 =?utf-8?B?UlVJdGJMQ0gxOHdEZ244VGc4MHlkeUNtaXFPcnpwSUZUWmlzWmJuTkRISUEw?=
 =?utf-8?B?OThaVTh5MTVwdGJ3TjJjL01td1ZNV0ZNL0FnY1Z0dEdkSWZwRm1qV25jZkM4?=
 =?utf-8?B?UkZHSVJxcWZ3TG9KRUFBQVJpb29FcmkzbVMyaGJLOWx1MEY2UEx6N2lLa1Qx?=
 =?utf-8?B?VGp2NEE2Y09HTkNSOGRlOENPeWxJa0lOcHZHSHB6Z3lmRTNnclY5NmpJbVNL?=
 =?utf-8?B?U0EyQ1JGZkRZZE5IS0ZEdVljblNRa0ptKzR6TEpnMXdWMDRMVFhaWVU2dHoz?=
 =?utf-8?B?cEtjZWdUWjZ3bDljQTgxWTM2NHg5N0JsdGlBWDZXSjI5Y2FhOTF0aTd6UFVr?=
 =?utf-8?B?SVlVZUJhM2FTbDB2WDVDdDFna0dZY1ZyY29mR3B1SytkNXAyOHZGTEdSZDRj?=
 =?utf-8?B?dFB5Yk4xMzdja2pxRGVESkNPOE9ndWhFeXVlWHZxNDBrVTd4bnNPMlcwakY1?=
 =?utf-8?B?MGo0Y2pCbWFlSDVBNHVpbUI2TkIyS0x4aVBMQnZtZG5rRTRnMUNTTG1DejA1?=
 =?utf-8?B?NW9IVFEzR0ZoTllYOW1Td2hYYXpIRWtnelVyTlp0ZW1VSWRGTEFITTR6eHNH?=
 =?utf-8?B?MEtzUVlhdldyQTZ2VXVOcy9rMXZrUVVZNlpQK2VxdE1CMFQ5NkRlYjd2VDZE?=
 =?utf-8?B?c2ZuTnZlUnFiNjZJM3RpTmhtUFNDNlNFR1JiVXBFc2ZQbXNhUzEvQUwycjdH?=
 =?utf-8?B?cmlkd1BTNGR4aHV0blVkWk9iR2V2MnRKbEtQdVkwTmQ5aU0vdlIxZUhRKzky?=
 =?utf-8?B?MUsrS0t2OEFkUFhlK2ZXWVlNQmpUeFFuU3BtdU9sQWFsYys5bXFTOFdCNWFq?=
 =?utf-8?B?SXJvSEVUZUJlQU9BQkJ0Q1FPZHp6aXc0NkRNdmF6ZG5oTUdBSU1sZi9zUjNv?=
 =?utf-8?B?eDU3c05QVzVUclJoUFVkRjMyT1R5YjRMNWRkWlRTYUhRYXJYNlQzay9QQ01l?=
 =?utf-8?B?L1NKM0Q1K3JkV3ljZGFlU3BXeUJTVEF4Um1ZTldta01ySHJ4bU1NU3p6Tkpk?=
 =?utf-8?B?UVNWMmJtbWkwZXVNZGhaZGVyK3g4U2hqTXFHUGZtOHVISitxK0xaSlFaN1F3?=
 =?utf-8?B?Zk1oUC9mRlMrVnh3Ui9xSk5JVWV4UWxOSHhmc0xiS2VPQW95U2R5SlhKYlE2?=
 =?utf-8?B?UjhtbnF2OUEzemJEQjVXSHF3c0d4MGNSL0dMT0Q3LzFpQXJRR1BKY0ZxWmhW?=
 =?utf-8?B?cENyYlBVbTF3Qm1FTGJGdEpCcGpMOGwwOEFxZEhiMFk3UHJ1OXVzakdyN2N4?=
 =?utf-8?B?dEttc0xNM3g5NTVGUHRGSGl3dkw1OGFjWi9MWlp2Z3Axd050K0ZQaEVDcGs5?=
 =?utf-8?B?TU16SWgwOFYyTGZUUFA5Y2M3NEFreUhiaWhSSTNQMGk0UmowZ3ZuTTdoYmVL?=
 =?utf-8?B?emltMnZLQTR5QkhtL1pTT0thWVlEc2oxUzlvOEVHaTJxN1dUUzFoOFNhRmY4?=
 =?utf-8?B?SElDcGNlZGdnMitmVGJOd3ZlMm5rYjJmL2c2R1hRczE0WUFiUDB1TTJ1NERh?=
 =?utf-8?B?VkRpVmVsVU5WamNwK045a3liYmN1YnliOENOUjlLVk8wYk1PK0FocUFmcXBI?=
 =?utf-8?B?cUdnVkZZU01RbGM5Wmk2QkVJMEdqK245bnE3NzkxeU1Rd0N0VHVPblJucFJZ?=
 =?utf-8?B?Y0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <89181CC910E8B949B878A4D6DF563BAB@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB4419.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c30ae08-4942-4bf2-1a36-08da703b8542
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2022 01:50:16.6804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6isN4VZXMLRWaRm3YlJ6kZbddCcqf+JsvwVMJ32Lj0en4QrzO7U0VZpAy0Fj32XA/b3J9QhhjEQAk5azs6KNyoag9oBl5aqQHWQiPuvpk0M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3575
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

b24gMjAyMi8wNy8yNyAyMTozMywgTWlrbG9zIFN6ZXJlZGkgd3JvdGU6DQo+IE9uIEZyaSwgMTUg
SnVsIDIwMjIgYXQgMTI6MDYsIFlhbmcgWHUgPHh1eWFuZzIwMTguanlAZnVqaXRzdS5jb20+IHdy
b3RlOg0KPj4NCj4+IFByb3ZpZGUgYSBwcm9wZXIgc3R1YiBmb3IgdGhlICFDT05GSUdfRlNfUE9T
SVhfQUNMIGNhc2UuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogWWFuZyBYdSA8eHV5YW5nMjAxOC5q
eUBmdWppdHN1LmNvbT4NCj4+IC0tLQ0KPj4gICBmcy9vdmVybGF5ZnMvaW5vZGUuYyAgICAgfCAy
ICstDQo+PiAgIGZzL292ZXJsYXlmcy9vdmVybGF5ZnMuaCB8IDYgKysrKysrDQo+PiAgIDIgZmls
ZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4gZGlmZiAt
LWdpdCBhL2ZzL292ZXJsYXlmcy9pbm9kZS5jIGIvZnMvb3ZlcmxheWZzL2lub2RlLmMNCj4+IGlu
ZGV4IDQ5MmVkZGViNDgxZi4uYmEyZGRlMjRjMWY3IDEwMDY0NA0KPj4gLS0tIGEvZnMvb3Zlcmxh
eWZzL2lub2RlLmMNCj4+ICsrKyBiL2ZzL292ZXJsYXlmcy9pbm9kZS5jDQo+PiBAQCAtNDYwLDcg
KzQ2MCw3IEBAIHN0cnVjdCBwb3NpeF9hY2wgKm92bF9nZXRfYWNsKHN0cnVjdCBpbm9kZSAqaW5v
ZGUsIGludCB0eXBlLCBib29sIHJjdSkNCj4+ICAgICAgICAgIGNvbnN0IHN0cnVjdCBjcmVkICpv
bGRfY3JlZDsNCj4+ICAgICAgICAgIHN0cnVjdCBwb3NpeF9hY2wgKmFjbDsNCj4+DQo+PiAtICAg
ICAgIGlmICghSVNfRU5BQkxFRChDT05GSUdfRlNfUE9TSVhfQUNMKSB8fCAhSVNfUE9TSVhBQ0wo
cmVhbGlub2RlKSkNCj4+ICsgICAgICAgaWYgKCFJU19QT1NJWEFDTChyZWFsaW5vZGUpKQ0KPj4g
ICAgICAgICAgICAgICAgICByZXR1cm4gTlVMTDsNCj4+DQo+PiAgICAgICAgICBpZiAocmN1KQ0K
Pj4gZGlmZiAtLWdpdCBhL2ZzL292ZXJsYXlmcy9vdmVybGF5ZnMuaCBiL2ZzL292ZXJsYXlmcy9v
dmVybGF5ZnMuaA0KPj4gaW5kZXggNGYzNGI3ZTAyZWVlLi4zZDhkZTE2YTc2ZTkgMTAwNjQ0DQo+
PiAtLS0gYS9mcy9vdmVybGF5ZnMvb3ZlcmxheWZzLmgNCj4+ICsrKyBiL2ZzL292ZXJsYXlmcy9v
dmVybGF5ZnMuaA0KPj4gQEAgLTU5OSw3ICs1OTksMTMgQEAgaW50IG92bF94YXR0cl9zZXQoc3Ry
dWN0IGRlbnRyeSAqZGVudHJ5LCBzdHJ1Y3QgaW5vZGUgKmlub2RlLCBjb25zdCBjaGFyICpuYW1l
LA0KPj4gICBpbnQgb3ZsX3hhdHRyX2dldChzdHJ1Y3QgZGVudHJ5ICpkZW50cnksIHN0cnVjdCBp
bm9kZSAqaW5vZGUsIGNvbnN0IGNoYXIgKm5hbWUsDQo+PiAgICAgICAgICAgICAgICAgICAgdm9p
ZCAqdmFsdWUsIHNpemVfdCBzaXplKTsNCj4+ICAgc3NpemVfdCBvdmxfbGlzdHhhdHRyKHN0cnVj
dCBkZW50cnkgKmRlbnRyeSwgY2hhciAqbGlzdCwgc2l6ZV90IHNpemUpOw0KPj4gKw0KPj4gKyNp
ZmRlZiBDT05GSUdfRlNfUE9TSVhfQUNMDQo+PiAgIHN0cnVjdCBwb3NpeF9hY2wgKm92bF9nZXRf
YWNsKHN0cnVjdCBpbm9kZSAqaW5vZGUsIGludCB0eXBlLCBib29sIHJjdSk7DQo+PiArI2Vsc2UN
Cj4+ICsjZGVmaW5lIG92bF9nZXRfYWNsICAgIE5VTEwNCj4+ICsjZW5kaWYNCj4+ICsNCj4gDQo+
IFNob3VsZG4ndCBvdmxfZ2V0X2FjbCgpIGRlZmluaXRpb24gYWxzbyBiZSB3cmFwcGVkIGluICNp
ZmRlZg0KPiBDT05GSUdfRlNfUE9TSVhfQUNMPw0KDQpPZiBjb3Vyc2UuDQoNCkJlc3QgUmVhZ3Jk
cw0KWWFuZyBYdQ0KPiANCj4gVGhhbmtzLA0KPiBNaWtsb3M=
