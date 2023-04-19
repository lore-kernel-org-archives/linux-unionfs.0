Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ECF0C6FD18
	for <linux-unionfs@archiver.kernel.org>; Wed, 19 Apr 2023 23:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbjDSXZJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 19 Apr 2023 19:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbjDSXZI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2023 19:25:08 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0850E5E;
        Wed, 19 Apr 2023 16:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681946706; x=1713482706;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/cMXZ6FFvFaNe2Gu5yF1TcbBSqpMmsH8LIHWlXhFPtw=;
  b=GM9lv+NBcG7Vacat0yCHGNenWg522QvC6HzdYshMjYDC6a6xldnas8PU
   BvNM51Y4gkROlPqQs04kClkqr1HLh7vunYsuXCcZEOUKUsuEFNb5ldpvn
   yjBoYB1OCrFdGKz+uE/6qWCE/uXy6FGA8dE5mHnLPBfXu1XYetfvDG1Z+
   A=;
X-IronPort-AV: E=Sophos;i="5.99,210,1677542400"; 
   d="scan'208";a="322482122"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-7dc0ecf1.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 23:25:05 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-7dc0ecf1.us-east-1.amazon.com (Postfix) with ESMTPS id 91ECB828FF;
        Wed, 19 Apr 2023 23:25:04 +0000 (UTC)
Received: from EX19D028UWA002.ant.amazon.com (10.13.138.248) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Wed, 19 Apr 2023 23:24:54 +0000
Received: from uda95858fd22f53.ant.amazon.com (10.187.171.36) by
 EX19D028UWA002.ant.amazon.com (10.13.138.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 19 Apr 2023 23:24:53 +0000
From:   Mengchi Cheng <mengcc@amazon.com>
To:     <casey@schaufler-ca.com>
CC:     <kamatam@amazon.com>, <linux-security-module@vger.kernel.org>,
        <linux-unionfs@vger.kernel.org>, <mengcc@amazon.com>,
        <miklos@szeredi.hu>, <yoonjaeh@amazon.com>,
        <roberto.sassu@huaweicloud.com>
Subject: Re: Transmute flag is not inheritted on overlay fs
Date:   Wed, 19 Apr 2023 16:24:39 -0700
Message-ID: <20230419232439.883241-1-mengcc@amazon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <7d5c10b6-68da-dea9-b460-1427b17250b5@schaufler-ca.com>
References: <7d5c10b6-68da-dea9-b460-1427b17250b5@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.36]
X-ClientProxiedBy: EX19D046UWA001.ant.amazon.com (10.13.139.112) To
 EX19D028UWA002.ant.amazon.com (10.13.138.248)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 2023-04-19 02:09:37 +0000, Casey Schaufler wrote:
>
> On 4/18/2023 5:23 PM, Mengchi Cheng wrote:
> > Hello,
> >
> > On the overlay ext4 file system, we found that transmute flag is not
> > inherited by newly created sub-directories. The issue can be recreated on
> > the newest kernel(6.3.0-rc6) on qemux86-64 with following steps.
> >
> > /data directory is mounted on /dev/vdb which is a ext4 fs. It is remounted
> > as an overlay again to upperdir /home/root/data.
> > # mount -t overlay overlay -o lowerdir=/data,upperdir=/home/root/data,workdir=/home/root/data_work /data
> > Add a new smack rule and set label and flag to /data directory.
> > # echo "_ system rwxatl" > /sys/fs/smackfs/load2
> > # chsmack -a "system" /data
> > # chsmack -t /data
> > Create directories under /data.
> > # mkdir -p /data/dir1/dir2
> > And then check the smack label of dir1 and dir2.
> > # chsmack /data/dir1
> > /data/dir1 access="system"
> > # chsmack /data/dir1/dir2
> > /data/dir1/dir2 access="_"
> > We can see dir1 did not inherit transmute flag from data and dir2 got the
> > process label.
> >
> > The transmute xattr of the inode is set inside the smack_d_instantiate
> > which depends on SMK_INODE_CHANGED bit of isp->smk_flags. But the bit is
> > not set in the overlay fs mkdir function call chain. So one simple solution
> > we have is passing inode ptr into smack_dentry_create_files_as and set the
> > SMK_INODE_CHANGED bit if parent dir is transmuting. Although it looks
> > reasonable to me and we did not meet any issue in testing, I am not sure if
> > there is a better solution to it. It will be great, if experts could take
> > a look.
> 
> I will be happy to look at your solution. Please post a patch.
>

Sorry, it takes me a while to review and send out the patch.
It contains a few files because it breaks kernel API. But the core is only
in the change of smack_dentry_create_files_as.

If Roberto's patch will work, we can drop it. I posted my concern in that
thread.
https://lore.kernel.org/all/20230419192516.757220-1-mengcc@amazon.com/
 
> >
> >
> > Thanks,
> > Mengchi Cheng
> >
> 
