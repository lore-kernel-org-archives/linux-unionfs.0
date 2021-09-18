Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F4FC433EF
	for <linux-unionfs@archiver.kernel.org>; Sat, 18 Sep 2021 12:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DDD46127B
	for <linux-unionfs@archiver.kernel.org>; Sat, 18 Sep 2021 12:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhIRMP0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 18 Sep 2021 08:15:26 -0400
Received: from mail-eopbgr1320057.outbound.protection.outlook.com ([40.107.132.57]:24703
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229579AbhIRMPZ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 18 Sep 2021 08:15:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWlfTwiQ9CNklXkBVJtOpNQqEmJCqo77pdF5NUZXruqXRtlECdILQK7kSxZ/+OB4pcFRZiz6tVb86Kk+geo1GVhKJtmwZP2CacOySsx3eFtpS7ORsurrQib5PJb0ZquIlGtTmC59H5ksXt3rpJ6Obexvb07QqpbgzM0ANPMbu3THJdk8HFDm5YfxCW1ENJLNuZTEQn+rHPuzN0lBDe+k5ABgnbOIZvI499Vp35URiHBaBKrpiIS25nx9nDCRcAShr7ZFwYiUKxSbUVWfkVZAU9paIgr4Bhez+F/vOwE7TSDLEznzMSnM7rQg6zFDf5rhRfY4zzp8nsoStSnDwB0cRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9gQzsxEu4J/o+6++pHUB6uF1nOISUw+evs4cBcNcmQM=;
 b=Xl2s68g/Gc2H6tJXyF0fQZvRNzE8q3AWPSGAx+1N67HutwV5jclk+41QM+qAGLx2kb1ionwuAZmv7MNA0Ex+F6A1yPbTQg35CZ7biQaxlNDQouAjWbscA8eL5efLp41g7pmhbJXShEKEEXCEctrtsqO3dmH+e9zOHO3l/KE3G7o2Dp8SEp8PqLdr6jsDh0sJkT2tdShWZrAb0s915u+KAcdz551pefSo/9urg1PfIONs4/VXkYa+npupB9UgZzacfedmjsXDl6MdWFrtasL1VvUJxzc8/1F226rxRdyedOrjf14BUDer49kiTwwnPkJFY3oJRxp+b2EJ0fSutJrZiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gQzsxEu4J/o+6++pHUB6uF1nOISUw+evs4cBcNcmQM=;
 b=IXwv7b4Sa9QqFqKOuoHzkM2h7SwYFQckXPxUEdT6nrWmfT3a8MwBmWwPbedaIdQCGyv4ubeSemhiUKDWx1pOoIE6YOKAAzAMiZkTlTkxhekVPSRmd2+VyotFuu1+10HoPBdAbuR4E6ChtW6dW3GQqAfSNIG64DYLLtldehx790o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oppo.com;
Received: from SG2PR02MB4108.apcprd02.prod.outlook.com (2603:1096:4:96::19) by
 SG2PR02MB2558.apcprd02.prod.outlook.com (2603:1096:3:22::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4523.18; Sat, 18 Sep 2021 12:13:56 +0000
Received: from SG2PR02MB4108.apcprd02.prod.outlook.com
 ([fe80::5919:768f:2950:9504]) by SG2PR02MB4108.apcprd02.prod.outlook.com
 ([fe80::5919:768f:2950:9504%4]) with mapi id 15.20.4523.018; Sat, 18 Sep 2021
 12:13:55 +0000
From:   Huang Jianan <huangjianan@oppo.com>
To:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        linux-erofs@lists.ozlabs.org, xiang@kernel.org, chao@kernel.org
Cc:     huangjianan@oppo.com, guoweichao@oppo.com, yh@oppo.com,
        zhangshiming@oppo.com, guanyuwei@oppo.com, jnhuang95@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ovl: fix null pointer when filesystem doesn't support direct IO
Date:   Sat, 18 Sep 2021 20:13:46 +0800
Message-Id: <20210918121346.12084-1-huangjianan@oppo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR04CA0050.apcprd04.prod.outlook.com
 (2603:1096:202:14::18) To SG2PR02MB4108.apcprd02.prod.outlook.com
 (2603:1096:4:96::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from PC80253450.adc.com (58.252.5.73) by HK2PR04CA0050.apcprd04.prod.outlook.com (2603:1096:202:14::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Sat, 18 Sep 2021 12:13:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2adc654-6f73-4144-ea0a-08d97a9dc901
X-MS-TrafficTypeDiagnostic: SG2PR02MB2558:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SG2PR02MB2558E4C27555DC5941F1E4A2C3DE9@SG2PR02MB2558.apcprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2RtJr5tKzG8LaPqu5qzAgxW1VIVvGeI2t7Gd123WomCV7mdXC+AboVQRsZMHijXlB7tCLl/AJG/aZJAyxvQmCn5DH9dO8QXKVdbwcFjOSsbc5HrnQhJ9IisPNT8rt9KzxRbcX++awKHhetQ1BA/JeQJdU9EI9PG+psSS/Nn6Awc/cndI6enraEdD7ih/AGNb61xHSsppAUwXVW9yuaS0Y39s7hpasyFe+8Vc/c6i/y0w8NXRPg34VUiZayAjRzemEQIUg0rU3Gl0u9u2DmWj4SI0ThWo9gcjAtjpWODS8FmxtYTFxKkLhxBhUUtN9+kGCySjZs8li+zzFihEKsGxuJxcmd1HFt4muQSVoLR/DWkx71RB+MSA45YWE9m+avaJp3UEptkYjpOETgeUQ9PHnrh/L0xNox4WFV8d9HgT8VKAY2kqGfq7PGbOROOkhzrKmKN6IAkKj7rzYEVvk2h+uKoQww33ThV4JJ5aZKvpIQ4caEOYj06rBGr+HvxK6dNiBEaiOnHdZV/i/e5ZGuGLf3oMC4amZg8yWmuZbU97NuZGsiO5wIVeZDsR4vaKkyHEWZHI9PLWnbXtLxvCwmCydxKif1zoBAuXzwMe4a+kPPiyUsa09qD9yfn8K845Nw/j/wjrk5Qbqap139ISoTSzAO5jgG85nv557bZnVt7SzRM4FrS72vUZjTvbu+GsfyT4jj3Hsp1R6K/CTbML6bU5PnU4kMiH0WOnkPVuU0OVGPA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR02MB4108.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(6486002)(6512007)(316002)(36756003)(2616005)(8936002)(8676002)(956004)(86362001)(83380400001)(186003)(26005)(6666004)(508600001)(6506007)(38350700002)(38100700002)(52116002)(1076003)(66946007)(66556008)(5660300002)(66476007)(2906002)(11606007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tO5qu+ZUo0sfh90uxAKQxZJ1tn84Qm40nSrADFubdrYsL9nVvuVhCHi/Wg0r?=
 =?us-ascii?Q?VG9MYoyfmUc//KqQks3U4JeiaJRbE9PtbbPkjmBF4OWxF0fOf7oW65A0ATQh?=
 =?us-ascii?Q?TTiRNPekShxlKoLlAFZ7QL/Tt5Pkv27pRBOVlaj4VRAcBaZQyzMUXL3IDsyO?=
 =?us-ascii?Q?n259DTum1NF6OeGuuKcbqh4+uCXsPtwUDG7Pl3JZQz7BXDOuFu8XUw79LK1G?=
 =?us-ascii?Q?A+R2kBZxauG4Tf1zrkU9gvWi9RmaEOWrvTOLcOHcKajB4jKeZER8G2UmQYbn?=
 =?us-ascii?Q?wuIuXHcytuWq4YNb0yHJk3sttEu3/vwzSTxH56auK6czRBnMVl09NVGf9bqV?=
 =?us-ascii?Q?C6Q4ZPkVw9yJY5jibKWfPGmWkpHGZuPHz27Rn3RibqEh2Fax5cPLUF8LGATs?=
 =?us-ascii?Q?mYMaDk2CXs64Tv04PQVwwPAN+nEvSrWuYx80KH9fXvaHXyN0GGSDquwfpVTi?=
 =?us-ascii?Q?Lvk/cVzmbi8XG9ZBlINlfPI40eHo0pHhZRmalJMswUuT3gSZoTzDzi1d9KhP?=
 =?us-ascii?Q?On8j1p9H4OGZ8rHc4hBthALCTNGD1Wcf9sFPc5y5KIIn19mr0ea9Iwzjb8JG?=
 =?us-ascii?Q?01GZLrsv/SoOkkRx20rRkI0w8f2xhgrS6dgJP323YQ8iUBKN+6o/4nztcyDe?=
 =?us-ascii?Q?YWsHZ3c28o8TwtR6JIYSIStiXDRBD1vDI+ZnAmJrte0llE+MdGa4NhTxHTez?=
 =?us-ascii?Q?MPRK60wLogPB3nz78QG7L9WXRq8JvOVG1SzrIRfq1kMt9fPKiUpPn/P+wKvj?=
 =?us-ascii?Q?7mb1+r2yVbCPDvU8QKXu5bvvzTGY+29bhP2EW6Q/Ve4WTSTCeU4oECvxdjCW?=
 =?us-ascii?Q?8jBc/MkXUEUaFv6pL8PVW3UyoYxvvUFIWSqWdz8zl+tVEm0WhFlgdW4vueD/?=
 =?us-ascii?Q?B3CY0rm6i2tM9m0wXNYsEFrEjob0UWslCj6zOZgjDNbP3mTTzChq6Art5QA7?=
 =?us-ascii?Q?cAsCqlYsSc/RSJ8ME08ybGY9goXLvX0PAkGYXbDNc4e2ttzs5MAFfziK7gPQ?=
 =?us-ascii?Q?65dOmtNWPc0R0zln/4wNdlWXilfU1EPTO06fIUmDYt/q/gNA4JPHJfpPNVf9?=
 =?us-ascii?Q?PKbnO8HKxxrqRurrg4LwBt5DRVevC0pARglD3DpM1oI8HBs7RW/uerO9xDKQ?=
 =?us-ascii?Q?tqgH67i/pipcBAOgSOGK3+xQBpLv9XTez+HaBTkl2pBOc8xXEg7bvWGOjj2R?=
 =?us-ascii?Q?mMSCyYaPZph1O7jLeAJZYMUgTC2xqTnI+wrFSrfNfzhXLBVoIhXJjNBIE9Dl?=
 =?us-ascii?Q?fq6SIWERZfE14NBSY++zG2Qcso9sXfUixM0KpOXfowowYt2+DAMp7ZgZQ5km?=
 =?us-ascii?Q?fSXL8KKPETOiR5TcIckGbbQG?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2adc654-6f73-4144-ea0a-08d97a9dc901
X-MS-Exchange-CrossTenant-AuthSource: SG2PR02MB4108.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2021 12:13:55.3903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 14mGS0BO90najrx2XVdURIig9AL9k64T2vrY+ATfocleiGGAtplQVz0Vqe5y8ZN0NUAuBpx0Jb3Hf0aLl5nb6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR02MB2558
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Huang Jianan <huangjianan@oppo.com>

At present, overlayfs provides overlayfs inode to users. Overlayfs
inode provides ovl_aops with noop_direct_IO to avoid open failure
with O_DIRECT. But some compressed filesystems, such as erofs and
squashfs, don't support direct_IO.

Users who use f_mapping->a_ops->direct_IO to check O_DIRECT support,
will read file through this way. This will cause overlayfs to access
a non-existent direct_IO function and cause panic due to null pointer:

Kernel panic - not syncing: CFI failure (target: 0x0)
CPU: 6 PID: 247 Comm: loop0
Call Trace:
 panic+0x188/0x45c
 __cfi_slowpath+0x0/0x254
 __cfi_slowpath+0x200/0x254
 generic_file_read_iter+0x14c/0x150
 vfs_iocb_iter_read+0xac/0x164
 ovl_read_iter+0x13c/0x2fc
 lo_rw_aio+0x2bc/0x458
 loop_queue_work+0x4a4/0xbc0
 kthread_worker_fn+0xf8/0x1d0
 loop_kthread_worker_fn+0x24/0x38
 kthread+0x29c/0x310
 ret_from_fork+0x10/0x30

The filesystem may only support direct_IO for some file types. For
example, erofs supports direct_IO for uncompressed files. So fall
back to buffered io only when the file doesn't support direct_IO to
fix this problem.

Fixes: 5b910bd615ba ("ovl: fix GPF in swapfile_activate of file from overlayfs over xfs")
Signed-off-by: Huang Jianan <huangjianan@oppo.com>
---
 fs/overlayfs/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index d081faa55e83..998c60770b81 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -296,6 +296,10 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (ret)
 		return ret;
 
+	if ((iocb->ki_flags & IOCB_DIRECT) && (!real.file->f_mapping->a_ops ||
+		!real.file->f_mapping->a_ops->direct_IO))
+		iocb->ki_flags &= ~IOCB_DIRECT;
+
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	if (is_sync_kiocb(iocb)) {
 		ret = vfs_iter_read(real.file, iter, &iocb->ki_pos,
-- 
2.25.1

