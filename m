Return-Path: <SRS0=188/=DB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836D4C2D0E2
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 16:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF9A123741
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 16:38:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="tL8n6vmI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgIXQiQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 12:38:16 -0400
Received: from mail-eopbgr50101.outbound.protection.outlook.com ([40.107.5.101]:64359
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726458AbgIXQiQ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Sep 2020 12:38:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCZtcj6sVzzOvkO74iAKUXgIF6GB8ouXCFRTTD6YFdM+RR93ANY+rtjmbW8pHH3jyDG+1vc3vBA4U7hWer4dDLKlvWIrV/snZPdlIkLOSA2tGsqHxbIJUyQgX0qYtGWmCL1lGrvIg9IdentqLZuGQgL7kGW3+kdeHnnFI0qUpZk2IlBuZrurKxyuzAeTKZyCtLgchfKUfzzVZzwZI0cdqfijr82CQLsJtTx7tNRlWBBTGacLkTOpx7NFlWKYVBD+pcBH41BEDhGM9JnNaJrKt8FVCudJYiwCZ3NB96gBUngPqIYEutLpnRO4Zk9VZMw0sUsiBs4Cs5ln4N9pOpfDow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j65g5N2xjjPc+P80xUOn25JpzaPzmbFRVZPh8vlif4M=;
 b=ZlJ9cBMznMOKntCHiOeqE2vgI7B2V0qftajHS1KlY9LTVqNN7d1T1kHerIdmUp0y8uyG1oZA1Awu/6a3GzZN8iQvSqTP3fkPwlLuVIB5yF3Q3sUf/v/Zvzaov5qU6Yi9jTeZ0DelNXSBL63sL0aKJMPXCkyHucWE1eriqr5M+VIymLk5e1idmqvaL2PWiQozJ0ZNIkx2JfkvwPQYqmJxnVf4kvqFzEdD1rRXoK3SwAzYR69J66gB5/xnPwxm4iS7QHwK/y6peX3XsdKxaTBeWYkP8QjhHg2qa/CD7IzcB5EYr7mZkk8AcgmrIun+VkIpsCLOCrKjx2OKEkYgvNWN4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j65g5N2xjjPc+P80xUOn25JpzaPzmbFRVZPh8vlif4M=;
 b=tL8n6vmIAlaIqhU4RGkzJ5kBAqYZC3bxUkVDGIgs/JPsifcJxBDnsG9ESuYHVlDbWomDUkkISpMVhGJ09yQmLcIB1UgnDLzQ0DiuGZvpmBb1g2dNZY3aTgR21Q8nxqilMR5TyzoCDVS1aUU5J3EXEcqximsS6J4yE25EoXiKHis=
Authentication-Results: szeredi.hu; dkim=none (message not signed)
 header.d=none;szeredi.hu; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (2603:10a6:20b:cd::17)
 by AM7PR08MB5430.eurprd08.prod.outlook.com (2603:10a6:20b:106::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Thu, 24 Sep
 2020 16:38:12 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322%7]) with mapi id 15.20.3391.027; Thu, 24 Sep 2020
 16:38:12 +0000
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] ovl introduce "uuid=off"
Date:   Thu, 24 Sep 2020 19:37:53 +0300
Message-Id: <20200924163755.7717-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0084.eurprd07.prod.outlook.com
 (2603:10a6:207:6::18) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (95.179.127.150) by AM3PR07CA0084.eurprd07.prod.outlook.com (2603:10a6:207:6::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.15 via Frontend Transport; Thu, 24 Sep 2020 16:38:11 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [95.179.127.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bdb5d62-657b-4e23-7252-08d860a83a59
X-MS-TrafficTypeDiagnostic: AM7PR08MB5430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR08MB5430A18DCBC6690982756A46B7390@AM7PR08MB5430.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 43dE3Dhn67zyMJCEV1N9sQwrhJ4kixa84IKKi7qKcC9RqChauaRZuyW3UyPm11ua+4oD32zbAfdr10eQQkJYKJllUZbfxhcDJSdKtqvssvvmpBvT7sTRrdh7b4TBWkAaz5Yc9NhnsiO0Dzq2obkjYZosjoSMviF3BNwmjJlUeiNaTa3wwDJ9XlCGAir9IJ0im51jACayDAA+9XYE8crRtE2rV4OEKS7NjRCpgATD8aQ63KWoJEY4cUFmCGcCsyzVqwF8D4gruLanP0zer2LFJh6LL/Hh+slUNNp56lYnx1Abf1XayPUcwjFMk3lhIeUqhj6ecmGVorR48Y0YqOMtevNvCIv9xAX6wyN2SYJFRJRg0K+Unjk1XBiRAurX+Ppd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4756.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39840400004)(376002)(136003)(52116002)(316002)(478600001)(186003)(6506007)(1076003)(36756003)(4326008)(6512007)(86362001)(6916009)(2906002)(16526019)(66556008)(5660300002)(26005)(8936002)(69590400008)(6666004)(6486002)(83380400001)(956004)(66946007)(2616005)(54906003)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: KMrYcA62NKDDLVZRb/DhdtNpbX0irRN09BEU5Ua/iJBGYpOySzR5Oc1fD/H3kePJxMT6lWbYdJg38yZ331++98lX9F03PpcDezRxeMOa3uqBUP0uj0ZjTqKvmtCEQuoQOIWLjn0+U/LPGLPgXe+oCnGldmDsoZWy8XDMwNscQqD5qPzyKKfHD5uBsdVVXh6oZe6fP5icvutsFrKsjnGTZ9q/8P1pHL1rDCIHJrQiWZ24wWSGgNEVwp5jG1WqDcXBLPh6vTpJZGxQwGdEtW3o5n+/AbyOPyUt57EjGeTg4qEbzWek2U9I0f0F7Hqtwbi2+wuQSCZnOxTG8tUOj6x9rQFYq9ukFWS8n2iLg7pbsKM92nM/z6saaxh4UIiHcdaJO0Psd4SKeH+wSePe2RT5py+UufLMvOHdgfgOqZJ8Qg4POTn/5gQ3cTyUkm/otNdhSVdeGlhePdAMsBgOg3FuDWUxqly1ZRWb2qjwf5IMYuswfto/T9IIMVZFE2qahEugX2lPxjhBT9xXxXF688tf2x5xwUQjrYrRaPM9WiODOhGI2y9IBoQ7gIN7/Pthmrf+V+0c6+ggTFli2hjglDa75GUGroSq72/qcXWAnt609jR4Mucq9oNvUx/DOAEegbzRqe4PSO5JW/EkvwoMbdQNEQ==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bdb5d62-657b-4e23-7252-08d860a83a59
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4756.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2020 16:38:12.4386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uKnISxa3sW5z6ZFu935AHPTf/19AnFHx8+ufR3Uv2pswkBL8FzEe1ZhCGfY8onh8kp2Gt2TAoOhY3H5NoXQGEdekaA4bI8Vqh+jWuEIGnrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5430
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This is a v3 of:
ovl: introduce new "index=nouuid" option for inodes index feature

Changes in v3: rebase to overlayfs-next, replace uuid with null in file
handles, propagate ovl_fs to needed functions in a separate patch, add
separate bool "uuid=on/off" option, fix numfs check fallback, add a note
to docs.

CC: Amir Goldstein <amir73il@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-unionfs@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Pavel Tikhomirov (2):
  ovl: propagate ovl_fs to ovl_decode_real_fh and ovl_encode_real_fh
  ovl: introduce new "uuid=off" option for inodes index feature

 Documentation/filesystems/overlayfs.rst |  6 ++++++
 fs/overlayfs/Kconfig                    | 17 +++++++++++++++++
 fs/overlayfs/copy_up.c                  | 25 ++++++++++++++-----------
 fs/overlayfs/export.c                   | 10 ++++++----
 fs/overlayfs/namei.c                    | 24 ++++++++++++++----------
 fs/overlayfs/overlayfs.h                | 14 ++++++++------
 fs/overlayfs/ovl_entry.h                |  1 +
 fs/overlayfs/super.c                    | 25 +++++++++++++++++++++++++
 fs/overlayfs/util.c                     |  3 ++-
 9 files changed, 93 insertions(+), 32 deletions(-)

-- 
2.26.2

