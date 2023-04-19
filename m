Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8536AC77B75
	for <linux-unionfs@archiver.kernel.org>; Wed, 19 Apr 2023 00:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbjDSAYF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 18 Apr 2023 20:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjDSAYE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2023 20:24:04 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BF4E79;
        Tue, 18 Apr 2023 17:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681863843; x=1713399843;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1U+PLJSAIes/H5by++o3LB2P2U8s/P5yLe1M8rRVXXE=;
  b=RZdSpj8M7dnzkjnggnFzOtKKG7iOhffv7O46RrfCqjLrA0Xf9T5DuffN
   5AW89s/ydZZFqu2S5fYGee0cYMrny6qz0l60Umfg9hp51/n6WiNjQDPQN
   GD8YcPyS0PVum4qkJO3n76tfqOvL8RX3obw08VWYxC172Z5i9eAZiwkHd
   A=;
X-IronPort-AV: E=Sophos;i="5.99,208,1677542400"; 
   d="scan'208";a="315568726"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3554bfcf.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 00:24:03 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-3554bfcf.us-east-1.amazon.com (Postfix) with ESMTPS id 88C2A803C1;
        Wed, 19 Apr 2023 00:24:01 +0000 (UTC)
Received: from EX19D028UWA002.ant.amazon.com (10.13.138.248) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 19 Apr 2023 00:23:49 +0000
Received: from uda95858fd22f53.ant.amazon.com (10.187.170.44) by
 EX19D028UWA002.ant.amazon.com (10.13.138.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 19 Apr 2023 00:23:49 +0000
From:   Mengchi Cheng <mengcc@amazon.com>
To:     <miklos@szeredi.hu>, <casey@schaufler-ca.com>
CC:     <linux-unionfs@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>, <kamatam@amazon.com>,
        <yoonjaeh@amazon.com>
Subject: Transmute flag is not inheritted on overlay fs
Date:   Tue, 18 Apr 2023 17:23:38 -0700
Message-ID: <20230419002338.566487-1-mengcc@amazon.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.44]
X-ClientProxiedBy: EX19D041UWB001.ant.amazon.com (10.13.139.132) To
 EX19D028UWA002.ant.amazon.com (10.13.138.248)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

On the overlay ext4 file system, we found that transmute flag is not
inherited by newly created sub-directories. The issue can be recreated on
the newest kernel(6.3.0-rc6) on qemux86-64 with following steps.

/data directory is mounted on /dev/vdb which is a ext4 fs. It is remounted
as an overlay again to upperdir /home/root/data.
# mount -t overlay overlay -o lowerdir=/data,upperdir=/home/root/data,workdir=/home/root/data_work /data
Add a new smack rule and set label and flag to /data directory.
# echo "_ system rwxatl" > /sys/fs/smackfs/load2
# chsmack -a "system" /data
# chsmack -t /data
Create directories under /data.
# mkdir -p /data/dir1/dir2
And then check the smack label of dir1 and dir2.
# chsmack /data/dir1
/data/dir1 access="system"
# chsmack /data/dir1/dir2
/data/dir1/dir2 access="_"
We can see dir1 did not inherit transmute flag from data and dir2 got the
process label.

The transmute xattr of the inode is set inside the smack_d_instantiate
which depends on SMK_INODE_CHANGED bit of isp->smk_flags. But the bit is
not set in the overlay fs mkdir function call chain. So one simple solution
we have is passing inode ptr into smack_dentry_create_files_as and set the
SMK_INODE_CHANGED bit if parent dir is transmuting. Although it looks
reasonable to me and we did not meet any issue in testing, I am not sure if
there is a better solution to it. It will be great, if experts could take
a look.


Thanks,
Mengchi Cheng

