Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE61ECAAD8
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Sep 2022 14:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiIUOsM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Sep 2022 10:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiIUOsI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Sep 2022 10:48:08 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730EC77EBE
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Sep 2022 07:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663771687; x=1695307687;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rkifJ5xWl+k7po7jTuhJds8hjiUIVXQJQpDSBD0wPkE=;
  b=jzffcJzP/WQtpRKwuCuHu54bKTqRAFNUVZ/iChUDtxpCAmr/HUwOfF2s
   jx/Q2wTAy8ugZqLOiRUTuwixdo7HmU1lTA6w7W0fs9RYGhTDOjcjDFJNN
   X94aLLC5GrLQTxVeV71K/eyUU3ZYhHAwcIxJQZKlIm4428I5p2F0Jd6FV
   Vw9MDzIxVaYuxAbt3vj8v46llD5/2i9Mhr3MpHXQxXzR80KsdLcAcDRrz
   kGcrQGkVcuuPZG5Nt0QAAFxob+CIHbPDxUD4MyZo5vAGExlqU6C9EUSNH
   Qd+SVMDBtWjwJEXi0PfMa71+0Uj82xlz0qts2HdQLMm2mayJ1WFJ6Gw0r
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="279746998"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="279746998"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 07:48:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="681796758"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 21 Sep 2022 07:48:06 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 07:48:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 21 Sep 2022 07:48:06 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 21 Sep 2022 07:48:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQLMhCUZcpdJ6HwNCfHVGZotpRzYFyascHLKg2sK5oC0sI77Dkx9eLeokn7GA3AfcIXFgLVD0gvaFnzfzFcaACzx6a//FucW6LhIhTkdq9wjYeGY26S8NgQqeB6S0D9syd+VUfyVBbw34Cgcz1oJmeA3RTyvRcbKrh1CLeD+jMkdOxdIdlZBuJTq5byochBMTqNTBJQAUeGHnkR/qdAlE5+Q2iK7TpJ8nRi06wMRfqn1Yoo5GiqvVPjwjiyjIG0zssKQGxpGTFz0rPVmWQdx8yd1K/6f3yilZkliCalq1rtyTvhCYtQnIRNEGFHJK5oD6rypEgXpEnFpKlgPY0qh8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rkifJ5xWl+k7po7jTuhJds8hjiUIVXQJQpDSBD0wPkE=;
 b=VH24WYdr8YJmGVK+fFxZqsRH2ZlFeWId6j66p1nglcXdeFSb6iWZ3cpM6HztlH5ha9Xi+Vb65XvCsHkmSkm1UnfRqtTRhkPwrxuFPkBymPBS2AkoH1SICkW0cTyGX8v/BTtdufLTdDQJXU2Sp0xqzwCVV2WDRM5dzw3ec4XGH3q+ZJV3DhiMUa0A1Wjo4iiOh9Cu+B2+ZM64P3oNJEtvmcI+DgP/+ETAxlmnCUnulZ13cgwsEln6LMY3Z9wg8PDdmC4ADEX8oDQREPWAQDn4kQtK4cm32qEb6qjbviPUJRWhwttwVJs65nKzINFsRpxB6uETLOtXG9AC0LZRxxG/+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1919.namprd11.prod.outlook.com (2603:10b6:300:106::22)
 by MW4PR11MB6960.namprd11.prod.outlook.com (2603:10b6:303:226::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 14:48:04 +0000
Received: from MWHPR11MB1919.namprd11.prod.outlook.com
 ([fe80::8d15:3832:ec23:f50e]) by MWHPR11MB1919.namprd11.prod.outlook.com
 ([fe80::8d15:3832:ec23:f50e%6]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 14:48:04 +0000
From:   "Jie, Keyon" <keyon.jie@intel.com>
To:     Amir Goldstein <amir73il@gmail.com>,
        Keyon Jie <yang.jie@linux.intel.com>
CC:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: RE: Does overlay driver work if built in to the kernel?
Thread-Topic: Does overlay driver work if built in to the kernel?
Thread-Index: AQHYzVFnvkOSexv080mvcPyfGOaDUK3pciuAgACDTRA=
Date:   Wed, 21 Sep 2022 14:48:04 +0000
Message-ID: <MWHPR11MB191913944274BE566826A4BEF14F9@MWHPR11MB1919.namprd11.prod.outlook.com>
References: <6810f0fa-ded3-420d-6978-0faf9667d307@linux.intel.com>
 <CAOQ4uxj1V8EvJuEthaiZK102P8PX4idFmC0BSTuhabPQo6kD0g@mail.gmail.com>
In-Reply-To: <CAOQ4uxj1V8EvJuEthaiZK102P8PX4idFmC0BSTuhabPQo6kD0g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1919:EE_|MW4PR11MB6960:EE_
x-ms-office365-filtering-correlation-id: 7de71422-643b-45fe-47d0-08da9be04a12
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4dCvJhdeKQAGDp5968MXh5UuBNBOL76gUI4UVYTVdPzGqTXqc7HOibcqzfJ8ePEjEjxr0AZoPXNulHmO7tSpncrGr4nHwHRuhTlRPvPoPTq6r9jM6KSbMEXINLH3R+LKc1oTCXqjguBOJFIfoW65tXZRxf8YiU6U8NqvCkFK8h1dEp7sZ/M+sELnnVZLCA1VG2IlbdmI2FnjvaSDhE5UenK5LOcaFOuPDhRxdrVQKSow8x3tCNJ9lxDBHJnS80Y551cGmN/vxh9+2fmbk6YQGUCXOpueWnv4WOGcsK3dOcvQre4UByamk6PpAo+p+Xw+m6vo0YT2egkkIAnqo4c7tKoGhDz9trD3ohHPzjeORLZZdNXAiF+N9fBCDCeYiYHG90SmpAIujZqpznS4K/djpXOWZrlpXm0H10XabPBBvrzHgFev6+xs/goKt/sJPWMlUtQqZ5Yy0kAy8CwdhgKAQSnt6c31FyRub3KXZCvFx2v38lPS4vx8Pe6AmwaLxmQo+qV2Vd1fKwIrgEz59gG99uEldcjjrU142jjZTm07CjfH2VeOj7Hok28C4ZnTY6tID27iHKsz5U64/NLLPFo6ApzXSTvMCjQb32mAoIAuRCZpgqcKY31/LP1S1hsldFwt0P0sRo7ICiARZc7JWXQSy9PEIWYwej3o0ozhLmk02sUGtUTgmtZvBgenh8W+w7UEWXR7SqVqcc5oVN9CCAN/PaxjJeqOeMUY5ftFx/RohMRip5tubQHILwymxBEEDhpr7KXT/liU0JsjYHqOZJsDJpRikM6gJ45aZy8ye4V6dRA6AMbrPUHbf79pC5lUJFaf4dOeCBYR8DnrwVDnMi+/YQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1919.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199015)(52536014)(316002)(83380400001)(966005)(76116006)(4326008)(8676002)(66476007)(66556008)(38070700005)(66946007)(64756008)(2906002)(66446008)(86362001)(33656002)(38100700002)(122000001)(82960400001)(478600001)(71200400001)(53546011)(55016003)(9686003)(26005)(186003)(54906003)(5660300002)(110136005)(41300700001)(8936002)(7696005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWpYejRwaU9NWXlQSkVNUFBrTW5KeWlrTCtQR2l6aSticDY4bWZ4czFxbUxl?=
 =?utf-8?B?YXlTc0dEckZqZnAwOWxWNjhxeVNBY0Y0UStubEUrNWs3MEpseXNPMkRKQ2xR?=
 =?utf-8?B?RmU5R0hJVC9UWTQ1a1BPQXI1dnM2VDNyRWF6S0NOTjhSZ2JWc2pXSUJkS1F5?=
 =?utf-8?B?R05LOW0xbEUyOHpmdkswTDFvd1BaekhTb1RVTnAwSWFoSDFRMmNvVVBGRExx?=
 =?utf-8?B?Vzl5dVVEUWM5aTEvZmw1OGNLYWFZVWNCaFk0MGpacm9UQnRsNXgvR2hGWWE4?=
 =?utf-8?B?NzVzbnFUMlJXckwvS2h1QytWMSszWXM2eEs3b05pUitFaU1RaFhSU1ppZ0wr?=
 =?utf-8?B?OEFldy9OR2dwYXhtYS9XaGZ1MjNVMEFxYW9YdTZWNjluWFhjdlE5aTJZSU1q?=
 =?utf-8?B?S1JXeE1ZdFhFVGgvOWEyWGFOcWJndTVzbHhJTCtGV1NwaVJadVRqNDVyc1E2?=
 =?utf-8?B?bGUrY0dLVmZtN203V3JSOUFQNlpMdVdmMHZsaWcyK1U1Um4yRDRtVzBDQUlj?=
 =?utf-8?B?VEwxV25QR0RjdXppRWxGbnhwR01pSysvczA3TW9hc3B3NEhTQlJjRWdnM0Vk?=
 =?utf-8?B?NlR1V3VNSGd1aHZVQnRCSG1LUGRlc0VHb1dzMzJRdERodEU2R3pEN3R5eWV4?=
 =?utf-8?B?RkpFV2RPWDlvd1lWR0xiSjJ5czJrZ2ViWGJuekx5OXUvQ2VGaU1KZ1lYbGt4?=
 =?utf-8?B?SG1iUGFvMy9nelh6M1VQSHZrcnM0Mjd6cjQwTTAvdDNIYjlJM2wzYXpOODRn?=
 =?utf-8?B?Y0tCSmYwSHdDMFcxWlhpU0ZDbWgyWUFRWkNhMWJ2MDM3bFhuWHhPSnZFc3Jo?=
 =?utf-8?B?aVpRS2QwaXQ4ZTgvRWF0dmxDQmZzeWN0L0RxTG9XcFJ6N1BrN0E5dkdmVGNY?=
 =?utf-8?B?T042ZW1Kb1BJQS82bFpPbC9rQkJQa3FyRDVQWEJPQWZjWlExam5wMWtFQ0hJ?=
 =?utf-8?B?YmpPc015UG4zNktFZEV2TWpRT3MvR3RFQnJzZ3djWXloZy9xNDR2NmRSVWZi?=
 =?utf-8?B?dUtwczJ5RzJtN1RZcGxvcitzL3NCWnk3WFZ3SnY2bmNWbjdGY3hmeThMOVdo?=
 =?utf-8?B?Uk93ekpiajRBU2RFWko2ODdZTGNFMnlLYkhIZGZCY0ZZNFE2SjdCd0tEUndj?=
 =?utf-8?B?cWNHcjdTSWJNSXhlTU1Sa1YwWThqU0lzRVdKY0J4UERQVEs4bzJCYXpxVGVH?=
 =?utf-8?B?MFJJRVVVdEJ2ZDJxS3lkSFZLSTdXdWd4SFJlSVNTRmJFeGJHaEJCZGt5VFdX?=
 =?utf-8?B?YjBMbEdXU2RxOEoyQ0MyK3VtTHJHMnB3cFNwbWlkbDgyallhUXRxNUk0OG95?=
 =?utf-8?B?bUc4MkNLNFg4T2Vnbm9GalYyeUt0SWdzaExUS0tNcWJVTm5UalJCN1ROd01B?=
 =?utf-8?B?eEtMeXo5OWJGdzlyUXRTdTBBb3RSNkM5VkdnVTFIOG5RcjVHSm5Sd09EV0JY?=
 =?utf-8?B?MENlRnRONGpLTEFQOEtidHNvV0xEdmpzSVRRR25SOXFuRGV0U21uNlZiVlo3?=
 =?utf-8?B?RmpxMk1BbzBVRXBIMzlVS0w0eVVmZm8rd3V5bm9RYnJBWHFaWWtORU9ZVTgz?=
 =?utf-8?B?UE9tbkcyTUx0Q2g5cnRCZXFvQmxqMnNqREF0SnBjU1Vqazc1UWxqcjBjQVVL?=
 =?utf-8?B?YVkzNzVHUmZDWjJOMk1Mc20xNGlrYVp6VXpuTitCb3JZY21EZ2FmRXRmdk9i?=
 =?utf-8?B?b0RsNDY3aFpNeXlEdDJmQTRubk1QckdsYTkzT1VJQzF2TUx3alFxT05uZnAx?=
 =?utf-8?B?ZktTNS9iSVJqdTBMWUZiN1JCNFRYbjA1YWcrTzNtSEN1RnEwbTFFNGtHSTJJ?=
 =?utf-8?B?V2FINEFhKzE4Slp0QXA1SVVMc25pL3FUVVlxaE5WaEpkRG02dHh4OElwV0t0?=
 =?utf-8?B?NklCZjNVVkhkbkFQM1BobFNmK09GQmc5UVVvUHdocGhEeUpON0o0NVRnRDI1?=
 =?utf-8?B?VWc4RjVyTGtvQkxZZTV0eTgxS09aWFpZQTdoUk9nQ0FaRGZwRU9oTE5ReVRJ?=
 =?utf-8?B?MlVlK1I0TjgrUGl4YjBrRVRiUUhNTzZpZENnZElGVTlzSk13a3c4bzN1eSsx?=
 =?utf-8?B?KytvSjVZQUtDbDdHUmNXM2JGSDJlNjYrUUVZYmlmeHF3bHRTaSs2L3BDS1ls?=
 =?utf-8?Q?ypummzQRy+5ECyOumOrjst3UN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1919.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7de71422-643b-45fe-47d0-08da9be04a12
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 14:48:04.3413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jdabD5CHXWqGVn7NTptZQdYLw203v0aKeBBKWT6I61Tq1YzAN3anlrrGkKefOyZ+F+5Qks7Gs7i2KNz9meK4jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6960
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFtaXIgR29sZHN0ZWluIDxh
bWlyNzNpbEBnbWFpbC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIFNlcHRlbWJlciAyMCwgMjAyMiAx
MTo1MCBQTQ0KPiBUbzogS2V5b24gSmllIDx5YW5nLmppZUBsaW51eC5pbnRlbC5jb20+DQo+IENj
OiBNaWtsb3MgU3plcmVkaSA8bWlrbG9zQHN6ZXJlZGkuaHU+OyBvdmVybGF5ZnMgPGxpbnV4LQ0K
PiB1bmlvbmZzQHZnZXIua2VybmVsLm9yZz47IEppZSwgS2V5b24gPGtleW9uLmppZUBpbnRlbC5j
b20+DQo+IFN1YmplY3Q6IFJlOiBEb2VzIG92ZXJsYXkgZHJpdmVyIHdvcmsgaWYgYnVpbHQgaW4g
dG8gdGhlIGtlcm5lbD8NCj4gDQo+IE9uIFdlZCwgU2VwIDIxLCAyMDIyIGF0IDM6MzIgQU0gS2V5
b24gSmllIDx5YW5nLmppZUBsaW51eC5pbnRlbC5jb20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gSGkg
YWxsLA0KPiA+DQo+ID4gSSBhbSBuZXcgdG8gdGhlIG92ZXJsYXlmcywgSSBhbSBoaXR0aW5nIGlz
c3VlcyB0byBtYWtlIGtlcm5lbCBtb2R1bGVzDQo+ID4gd29yayBpbiBhIGNvbnRhaW5lciBlbnZp
cm9ubWVudCB3aGVyZSB0aGUgS3ViZXJuZXRlcyBmZWF0dXJlIHJlYWxseQ0KPiBuZWVkDQo+ID4g
dGhlIG92ZXJsYXlmcyBzdXBwb3J0Lg0KPiA+DQo+ID4gSSBmaWd1cmVkIG91dCB0byBtYWtlIG92
ZXJsYXkgZHJpdmVyIGJ1aWx0LWluIHRvIHRoZSBWTSBrZXJuZWwgKGFuZCB0aGVuDQo+ID4gc2hh
cmVkIHRvIHRoZSBjb250YWluZXIpLCBidXQgbG9va3MgbGlrZSB0aGUgS3ViZXJuZXRlcyBhbHdh
eXMgZmFpbCB3aGVuDQo+ID4gdHJ5aW5nIHRvIGNyZWF0ZSBvdmVybGF5ZnMgbW91bnRzLCB3aXRo
IGVycm9ycyBsaWtlICdwZXJtaXNzaW9uIGRlbmllZCcuDQo+ID4NCj4gDQo+IFVzdWFsbHksIHlv
dSB3YW50IHRvIGxvb2sgYXQgdGhlIGtlcm5lbCBsb2cgdG8gc2VlIHRoZSByZWFzb24gZm9yIGZh
aWx1cmUuDQo+IFRoYXQgaXMgbGlrZWx5IGJlY2F1c2UgdGhlIGNvbnRhaW5lciBpcyAidW5wcml2
aWxlZ2VkIg0KPiBtZWFuaW5nIG5vdCB1c2luZyB0aGUgc2FtZSB1aWQgMCBhcyB0aGUgaG9zdC4N
Cj4gDQo+IERvbid0IGtub3cgd2hpY2gga2VybmVsIHlvdSBhcmUgcnVubmluZywgYnV0IG92ZXJs
YXlmcyBjYW4gYmUgbW91bnRlZA0KPiBpbnNpZGUgdW5wcml2aWxlZ2VkIGNvbnRhaW5lciBzaW5j
ZSBrZXJuZWwgdjUuMTE6DQo+IA0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC0NCj4g
ZnNkZXZlbC8yMDIwMTIxNzE0MjAyNS5HQjEyMzY0MTJAbWl1LnBpbGlzY3NhYmEucmVkaGF0LmNv
bS8NCg0KVGhhbmsgeW91IEFtaXIuDQpJIGFtIHVzaW5nIHY1LjEwIGtlcm5lbCwgc28gbG9va3Mg
SSBjYW4gdHJ5IHRvIGJhY2twb3J0IHNvbWUgb2YgdGhlIHBhdGNoZXMgYW5kIHRyeSBpdCBhZ2Fp
bi4NCkkgYXNzdW1lIHRha2UgdGhlIDEwLWNvbW1pdHMgc2VyaWVzIGZyb20gTWlrbG9zIHNob3Vs
ZCBiZSBlbm91Z2g/DQogICAgICB2ZnM6IG1vdmUgY2FwX2NvbnZlcnRfbnNjYXAoKSBjYWxsIGlu
dG8gdmZzX3NldHhhdHRyKCkNCiAgICAgIHZmczogdmVyaWZ5IHNvdXJjZSBhcmVhIGluIHZmc19k
ZWR1cGVfZmlsZV9yYW5nZV9vbmUoKQ0KICAgICAgb3ZsOiBjaGVjayBwcml2cyBiZWZvcmUgZGVj
b2RpbmcgZmlsZSBoYW5kbGUNCiAgICAgIG92bDogbWFrZSBpb2N0bCgpIHNhZmUNCiAgICAgIG92
bDogc2ltcGxpZnkgZmlsZSBzcGxpY2UNCiAgICAgIG92bDogdXNlciB4YXR0cg0KICAgICAgb3Zs
OiBkbyBub3QgZmFpbCB3aGVuIHNldHRpbmcgb3JpZ2luIHhhdHRyDQogICAgICBvdmw6IGRvIG5v
dCBmYWlsIGJlY2F1c2Ugb2YgT19OT0FUSU1FDQogICAgICBvdmw6IGRvIG5vdCBnZXQgbWV0YWNv
cHkgZm9yIHVzZXJ4YXR0cg0KICAgICAgb3ZsOiB1bnByaXZpZWdlZCBtb3VudHMNCmh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xpbnV4LWZzZGV2ZWwvMTcyNWUwMWEtNGQ0ZC1hZWNiLWJhZDYtNTRh
YTIyMGI0Y2QyQGktbG92ZS5zYWt1cmEubmUuanAvVC8NCg0KVGhhbmtzLA0KfktleW9uDQoNCj4g
DQo+ID4NCj4gPiBJIGFtIHNlZWluZyB0aGF0IG92ZXJsYXkgZHJpdmVyIGlzIHJlbGVhc2VkIHdp
dGggbW9kdWxhcg0KPiA+IChDT05GSUdfT1ZFUkxBWV9GUz1tKSBpbiBtb3N0IChub3Qgc3VyZSBp
ZiBpdCBpcyBhbGwpIExpbnV4DQo+ID4gZGlzdHJpYnV0aW9ucywgc28gSSBhbSB3b25kZXJpbmcg
aWYgdGhlIG92ZXJsYXkgZHJpdmVyIHdvcmsgd2hlbiBidWlsdA0KPiA+IGluIHRvIHRoZSBrZXJu
ZWw/DQo+ID4NCj4gDQo+IEl0IGNhbiBiZSBidWlsdCBpbiBvciBtb2R1bGUuDQo+IFRoYXQgc2Vl
bXMgdW5yZWxhdGVkIHRvIHlvdXIgcHJvYmxlbS4NCj4gDQo+IFRoYW5rcywNCj4gQW1pci4NCg==
