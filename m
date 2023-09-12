Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB2BBEE3F11
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Sep 2023 19:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjILTuE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 15:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjILTuD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Sep 2023 15:50:03 -0400
X-Greylist: delayed 3762 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Sep 2023 12:49:58 PDT
Received: from mx08-0040c702.pphosted.com (mx08-0040c702.pphosted.com [185.183.31.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EDC115
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 12:49:58 -0700 (PDT)
Received: from pps.filterd (m0267678.ppops.net [127.0.0.1])
        by mx07-0040c702.pphosted.com (8.17.1.22/8.17.1.22) with ESMTP id 38C1TKSd025936
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 18:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlstorz.com;
         h=from:to:subject:date:message-id:content-type
        :content-transfer-encoding:mime-version; s=S-DKIM-20210427; bh=X
        O2MWhdb+lK4d+Z76lr2I066Ztaps9kDJ7zHBg7Z9n4=; b=WkxJBQdWVoWmlhnpc
        CR+Szt/enllg+5lp9SShdfqpChq2ficTe7ePuicOBaf0EsIyLKdO/UuJLt1rbOaQ
        J5nwlVnPHJ79fUEhP7boonjYI3mv4tutJkgstfOXDv/HFO2XwuTd51R/jo6KcnK0
        5xkhndDqHgyoO0xhFeEMMmk+b0pgZZllH92E/dQypqk6duSkxWFt9NvUZF914u2m
        B+9zMhpYhni44C8f4KctzNd6jXQmvOhsdkEi8rBgx7ynf97tgCOplPuuDX98ChV0
        4Wrkwgml4DhFlgnjpkuCjrD7T/WqMYZwCyQ5tMaFgcv0XpDFU6bZTkdcro58bfH/
        peA6A==
Received: from eur01-db5-obe.outbound.protection.outlook.com (mail-db5eur01lp2059.outbound.protection.outlook.com [104.47.2.59])
        by mx07-0040c702.pphosted.com (PPS) with ESMTPS id 3t0fmb314x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 18:47:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqCOFVsdm97SYhx86aWHHQkV47z1KOOrg2lnmRG73a2SyupuxSkwxb6mEtBbPr5jiz6l4hcFpBtVeyKkx/zbNBaQ608Qw1YsjTGdAXJZm4dO091wDl2o491OYo+GlbwT7zqCJTecAdynZsZrq0lzJfyP0koExTqTP28hRlEtj8zqODGQyj7+ipAmuOXuVrU2hDjRps/0SbFyawDrbxWy+5wZN5aE8mzESJSqFQ/TVvPncxvIHLmkuyr7nD4hXVLgIeXJyxyetVAMhLviP+OBvCjaZldj1/imLjHwZzklQietjfpOFQbnxHmC7MtPC+7WynfZQ//ao2meY6C4vPP2rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XO2MWhdb+lK4d+Z76lr2I066Ztaps9kDJ7zHBg7Z9n4=;
 b=YQH08xtZAH345kntocCkBFGP/HMWEVlZV0WimeJMgJPQkyQ4PK6NWuaUWR65BwPRbIRnYdWri4cxLXkFDlT8GpqcVps3QUJOvVGqtYuDfyro70t/fPW7mjVqR16bCP2rawXGDBRgygyjOPZ4+S+7h+bRKv3n/kNWzBN9qhPqdSDN6s8mcEDluhHM0PM7ngHnHuGw4zx1Kn63HZkRvtA8eF37RqwGMRVAcfODYJBp4OCZP3r9RaxbbpVr+3FnNSqMi+hS9RMoDWEckUZT7UJ2HREi7CLYH4XyjoSDmvmij7ZPyAOXzlQ8Av4m0WpRjLDYWRXrko+oQLS2EXNQLizjAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=karlstorz.com; dmarc=pass action=none
 header.from=karlstorz.com; dkim=pass header.d=karlstorz.com; arc=none
Received: from DB6PR01MB3736.eurprd01.prod.exchangelabs.com
 (2603:10a6:6:4b::33) by AS8PR01MB7527.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:2a6::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.15; Tue, 12 Sep
 2023 18:47:10 +0000
Received: from DB6PR01MB3736.eurprd01.prod.exchangelabs.com
 ([fe80::91fe:d06c:d05e:e7fc]) by DB6PR01MB3736.eurprd01.prod.exchangelabs.com
 ([fe80::91fe:d06c:d05e:e7fc%4]) with mapi id 15.20.6792.015; Tue, 12 Sep 2023
 18:47:10 +0000
From:   "Sebert, Holger.ext" <Holger.Sebert.ext@karlstorz.com>
To:     "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
Subject: Quota on OverlayFS supported?
Thread-Topic: Quota on OverlayFS supported?
Thread-Index: AQHZ5al7Az3PGWuDSkaig+FoTYCYAg==
Date:   Tue, 12 Sep 2023 18:47:09 +0000
Message-ID: <DB6PR01MB373613B9CD1198A409333D77A4F1A@DB6PR01MB3736.eurprd01.prod.exchangelabs.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB6PR01MB3736:EE_|AS8PR01MB7527:EE_
x-ms-office365-filtering-correlation-id: 867d3f2f-3292-4ea3-9479-08dbb3c0aba1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3uWhXAMfXpMCV550V2JezGzihVegaLkc7HrOKY12gLply6jJXfRBzvM0Og9JsJgZFJx5SW38K+uvg9YH0O4LrYYv2NHPHR42cVqXhNl/pNSm3gzcntpL5vTfSAgVu6h5hBkfi9qD2ykgnOz9IM8uodPV3TJuAUDDrRUrQNFFW9euWbFChExIXjv+2wpulud/NN9N3mGhsmZLJ6mzkRlz9Gs/uj9S9pEgE5Hn2LJ8R+fGvGzi8kKj7Te06yaDzk/Ibauby1TM22zAr+VJWWJAaPYEkJ8hBDsy6qxmKpQidlEVXmQ8Pg9VV+Sbu5JecGrx+hBN40j9QmfYa0fqotjtYl2BHbFD/Qe3rk5n2ZhpzMKwAqM9jwlXTCGggAIz1VgUazvLFdt6QVGAmIakSzvXCGqFOX3YffE0F9SOGaufWiu9loBkTNgj1iaxrITG6VtuQ3G6vdk32E2VmaW9kve+H/9SU2BUzWTck+5sLGwnf09q7VvJmJ7z4V4MCba3DBQYjmxawnLK6mNMfDkoZmVOqd54cxhAqtLV0ZvOKLyf2RpQJuLyFzrZnOaoYHEUl+CcqdqvrhPFii2kTLqVcr8sKlckZMgvOXz8sCx8GLA3LhNLocpcms5BkmVisT/MLd6S
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR01MB3736.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199024)(186009)(1800799009)(91956017)(76116006)(15650500001)(41300700001)(4744005)(55016003)(316002)(8936002)(8676002)(66446008)(66556008)(64756008)(66476007)(6916009)(2906002)(66946007)(5660300002)(52536014)(478600001)(9686003)(7696005)(6506007)(3480700007)(38100700002)(122000001)(26005)(71200400001)(83380400001)(38070700005)(86362001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?n+Ut5qkwjPTyVP63oNAwEWSdeCpBHvmu9+Mlzme3uJeQVSEuK09UysF+G/?=
 =?iso-8859-1?Q?06gY6lIwTshr2OkbMH7SYOpG2vKdXhbCT4gelEW480dY4fJ1J0D51tqexm?=
 =?iso-8859-1?Q?LZTBXjxiylvh92xjob08uKUVYYwa3mlXYqpiok7HyyZfnjqpdHGYoIZmtm?=
 =?iso-8859-1?Q?DWrCSlTd36kpzFndBzFxs7SpdK8QPB8t09MGJ8YAd30itLNsc4km4yRh8f?=
 =?iso-8859-1?Q?i0TFxn7Wkxcsxe3h3GsKsQU1DxuL2FVwu7UO8LAqDn03rUZEW7ldgEQp1z?=
 =?iso-8859-1?Q?paZls4Qne+lhnCix34+L+R6UTwEV0/d1k20mx9hbAXZJ1RzG4k/JSgJPH6?=
 =?iso-8859-1?Q?kzInTf+/KGrSU/J6CYz+Xs6MKFxpcUuJTX1kJEVMAwLc6PXEy4QIPIa8UQ?=
 =?iso-8859-1?Q?XByN6kpVByWMGdGs4jU033Tk1GSkij4i/yYR6PSgwRVpMfCGE+Co6/3bQh?=
 =?iso-8859-1?Q?MirT79vMpaKCGgiHLHDhWbHmaDJW3HbGcmXXSvWsCqWsTrPIdIrvwIhHnd?=
 =?iso-8859-1?Q?HwajMSO7Ex4JIb76c9BlGwQd9vqsn4UaBDVD0p6BIRyqr72WPaX/2hNO+Y?=
 =?iso-8859-1?Q?hZnWpexShk07kdCMKlgUoejWU5U8XUchKF7KJpR/xheBf6o9txtqLeJPNl?=
 =?iso-8859-1?Q?fTUZqOPIYxNft6FMqtQ2nZ++kbgcKw6btXrNcW4oAN8/cQ354w+mZ+jocU?=
 =?iso-8859-1?Q?MxH0U3+QL5QigXyjnADZlMkvt0ZQrFO91kvKgju76pTCl+aEY43FbwAsRV?=
 =?iso-8859-1?Q?NmbghZCyyxVt+YyFquWHWB7F+9GshogWJss+0RPPxiQ5JTWIQDsDlWIio6?=
 =?iso-8859-1?Q?YUisaQ7F6q1WHvCFq4wcxrYk32YFgDVUvv5PhW52a1VS9Mb6EMGfG53qOU?=
 =?iso-8859-1?Q?bE+62SqqJru8NQjKdmlKLmp8vq/q5BLpRvpZHZ8xo7u73BNrhCch7xswgn?=
 =?iso-8859-1?Q?vf9X4gQn7W1xy0LyI5MZKwm5CsbFvqFNZfk9CLMqMtD1iKxWkZyS2M2UL2?=
 =?iso-8859-1?Q?s4Dg6Bz6vrjUqD9l9Cr1Ulig+Rv0PqX0TSu/jrDZRRWUg+Wc4kCDa4phi9?=
 =?iso-8859-1?Q?jd0UyWziHg0VEkPSUr4ww6H3O3mC3V5alMR2+w0q+vRpxcgNllaUdjL39F?=
 =?iso-8859-1?Q?0sVO/zgUgUB0gBHLGDOhLPnYeC78zLS2mTCoLdd7cKJb+vKo2JcIh80QxS?=
 =?iso-8859-1?Q?lHMBUfBfPa75BpEONGHmCet7USklf5fKsRX2ju9FN7sw86qF2MA9cHHbwx?=
 =?iso-8859-1?Q?2zLHTC9M5PJ+FfXtK4beH0pEaoaMjztzZRBZnqNjwPRW9DxaUKeif8AmzE?=
 =?iso-8859-1?Q?eF201fMQ2LfbHfSTkQoB2qDuRfuKTfLA4gmQ8CmqVpeLY2pnSj4TsK/u7U?=
 =?iso-8859-1?Q?EmKJTqSvL4Skqjvkmj+gsFDmjq4q8tcfHC1cvFbCSMeEHuV9WpjSFDKxdQ?=
 =?iso-8859-1?Q?Fd4/EULfPD5SddN0CyNI27j+EvgcbEDBYAjMud6TxdslJSwSwJsRafYjkM?=
 =?iso-8859-1?Q?ENrfosE+xd/i4rlv6iUWoXfZJwlzXPzahq7r2jOApGOOFgDd2bhAGcV1AB?=
 =?iso-8859-1?Q?inohL/QrpicLVmPL7RHRUNL8w8sDQ+PjrEUHYAQYqZu8ET//bjrVkzGeCh?=
 =?iso-8859-1?Q?0LLpKbyhA2b6BXIhc0CWvjzpqkN1si7A5CPo9X4/Ciqwx7xeIyX5EVEA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: karlstorz.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB6PR01MB3736.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 867d3f2f-3292-4ea3-9479-08dbb3c0aba1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2023 18:47:09.7386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4a0b6f21-e6e1-4ed6-9dcf-e60e7190f648
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tskMPQJwrKwRcaGsGOQ3uq1gQgrwfIgPIdzgXL7apduiTQrcBcrx2fymDJpc7SN7tMzRGOX8IKRQs+6NiEWF40KMrlhmXGkDfA/stO7f2WQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR01MB7527
X-Proofpoint-ORIG-GUID: 5PacBCDPHbGVvn3tmpTX-5vDr7UhalKW
X-Proofpoint-GUID: 5PacBCDPHbGVvn3tmpTX-5vDr7UhalKW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-12_18,2023-09-05_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi,=0A=
=0A=
On my system I use OverlayFS. The overlay filesystem is mounted as=0A=
follows:=0A=
=0A=
    mount -t overlay overlay -o lowerdir=3D${ROMOUNT},upperdir=3D${UPPER_DI=
R},workdir=3D${WORK_DIR} ${NEWROOT}=0A=
=0A=
with the variables ROMOUNT, UPPER_DIR, WORK_DIR and NEWROOT pointing=0A=
to the relevant directories.=0A=
=0A=
I tried to activate quota by adding the mount options 'usrquota' and=0A=
'grpquota' to the above mount command as follows:=0A=
=0A=
    mount -t overlay overlay -o lowerdir=3D${ROMOUNT},upperdir=3D${UPPER_DI=
R},workdir=3D${WORK_DIR},usrquota,grpquota ${NEWROOT}=0A=
=0A=
While I don't get an error, the quota tools report that quota isn't=0A=
activated on the (overlay-)filesystem containing the r/w uppder dir.=0A=
=0A=
This makes me wonder whether quotas are actually supported by OverlayFS?=0A=
=0A=
I searched the web, asked on ServerFault, but did not receive a definite=0A=
answer.=0A=
=0A=
Thanks!=0A=
=0A=
-Holger=0A=
