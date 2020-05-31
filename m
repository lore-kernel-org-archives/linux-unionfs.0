Return-Path: <SRS0=LZCd=7N=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4127AC433E0
	for <linux-unionfs@archiver.kernel.org>; Sun, 31 May 2020 11:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18BE2206E2
	for <linux-unionfs@archiver.kernel.org>; Sun, 31 May 2020 11:02:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vzd/SsZg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgEaLCF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 31 May 2020 07:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgEaLCE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 31 May 2020 07:02:04 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959F8C061A0E;
        Sun, 31 May 2020 04:02:04 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id v19so8078520wmj.0;
        Sun, 31 May 2020 04:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=s5twvfxyAa1mllFYuUr59UMhuctZ8Rx8Cqr21XhINSM=;
        b=Vzd/SsZgcIoObw58XwjtGKEbCCZnM/RZXq1EtKTebe0moW7JMbPdOj3dD/8PPR0qeP
         KBXDG5PsnQy8tK6npXJhty9QyFaalAyjvcmQDcK2gAuJqJWG4e9MoXv2EKJzO01ZjOtO
         ccxCFKxaOzPLvWYPAdrnr1C/sJNqkHRe1N19+L6pc2qBsa2sTRrX+iaLXnQ9ycPLvdh7
         AR91X5I4BkCORg9Fd2pLmICU96MI2HsSkSvZMycxinEOd4ltblCwMjlT0lI9YuHQLJ50
         cWbnvEZyJBgheiYBBWTnYcZSdnx6cSTnUF/9pZ97ff6RM56UWyUvEsAXgZTBkVmCKeV3
         JTvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=s5twvfxyAa1mllFYuUr59UMhuctZ8Rx8Cqr21XhINSM=;
        b=GMDVfb5wwn2MBcWV3iYp8ZPp22LmWRWNpXlp9gpLUvp8FUq+YdA1GgPN+UM19ZMDG0
         uP1eg+jXYI1Br8ndhDhHQJ7iB9a//GlslzRi8+QMCbxXsqkZH1Rshok/fP5u+k1fmA7g
         oHMiyRy3Ju6dbItHbnsPV6nqoPMF3iy4sj6+s5kCGhCjpFwzntr2TV5z39fPFdMQVMoe
         0D9mh6oQ8FWHBfzKdg1EhY8F5lWcCerzlCLNRM1IRlngLN1ZPqCnyDjnsqjPoRdBpUvO
         9bZE/FhTrH2wEZ1JQR66EvSbGh1Tbvp8cbBqV51anWFn/Ce8zfMALz1z3YKpqi7IjYgS
         kcHQ==
X-Gm-Message-State: AOAM531OLNUPkO0S4sFHEW2oJ2gna9oDq9+WSvISrq/C89ZONwJAw5/P
        LYYSN0t9+Tnrgm4CYgSr554=
X-Google-Smtp-Source: ABdhPJxPZBk6NoFp5i5p9A2Cf4cHrkao5CTRKyHaUemslQcFVDboCx+cT185okLoLt9U354iL6eDfg==
X-Received: by 2002:a7b:c5d4:: with SMTP id n20mr17876666wmk.106.1590922923321;
        Sun, 31 May 2020 04:02:03 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id j190sm7846430wmb.33.2020.05.31.04.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 04:02:02 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH 0/3] Running unionmount testsuite from xfstests
Date:   Sun, 31 May 2020 14:01:53 +0300
Message-Id: <20200531110156.6613-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Eryu,

unionmount testsuite has a lot more test coverage than the overlay
xfstests, but it has a lot less exposure to testers.

The various test setups that I have added to unionmount testsuite since
I took over the maintanace of the testsuite have even smaller exposure
to testers.

These patches add overlay tests that are used as a harness to run
different setups of unionmount testsuite.  I have been using this method
for over two year for testing my overlayfs branches.

What does it take to install unionmount testsuite?
As README.overlay says:

  git clone https://github.com/amir73il/unionmount-testsuite.git
  ln -s $PWD/unionmount-testsuite <path-to-xfstests>/src/

Thanks,
Amir.

Amir Goldstein (3):
  overlay: run unionmount testsuite test cases
  overlay: add unionmount tests with multi lower layers
  overlay: add unionmount tests with nested overlay

 README.overlay        | 15 ++++++++++++
 common/config         |  2 ++
 common/overlay        | 54 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/100     | 38 ++++++++++++++++++++++++++++++
 tests/overlay/100.out |  2 ++
 tests/overlay/101     | 39 +++++++++++++++++++++++++++++++
 tests/overlay/101.out |  2 ++
 tests/overlay/102     | 40 ++++++++++++++++++++++++++++++++
 tests/overlay/102.out |  2 ++
 tests/overlay/103     | 38 ++++++++++++++++++++++++++++++
 tests/overlay/103.out |  2 ++
 tests/overlay/104     | 39 +++++++++++++++++++++++++++++++
 tests/overlay/104.out |  2 ++
 tests/overlay/105     | 40 ++++++++++++++++++++++++++++++++
 tests/overlay/105.out |  2 ++
 tests/overlay/106     | 41 ++++++++++++++++++++++++++++++++
 tests/overlay/106.out |  2 ++
 tests/overlay/107     | 41 ++++++++++++++++++++++++++++++++
 tests/overlay/107.out |  2 ++
 tests/overlay/108     | 41 ++++++++++++++++++++++++++++++++
 tests/overlay/108.out |  2 ++
 tests/overlay/109     | 41 ++++++++++++++++++++++++++++++++
 tests/overlay/109.out |  2 ++
 tests/overlay/110     | 39 +++++++++++++++++++++++++++++++
 tests/overlay/110.out |  2 ++
 tests/overlay/111     | 40 ++++++++++++++++++++++++++++++++
 tests/overlay/111.out |  2 ++
 tests/overlay/112     | 40 ++++++++++++++++++++++++++++++++
 tests/overlay/112.out |  2 ++
 tests/overlay/113     | 41 ++++++++++++++++++++++++++++++++
 tests/overlay/113.out |  2 ++
 tests/overlay/114     | 39 +++++++++++++++++++++++++++++++
 tests/overlay/114.out |  2 ++
 tests/overlay/115     | 40 ++++++++++++++++++++++++++++++++
 tests/overlay/115.out |  2 ++
 tests/overlay/116     | 40 ++++++++++++++++++++++++++++++++
 tests/overlay/116.out |  2 ++
 tests/overlay/117     | 41 ++++++++++++++++++++++++++++++++
 tests/overlay/117.out |  2 ++
 tests/overlay/group   | 18 +++++++++++++++
 40 files changed, 843 insertions(+)
 create mode 100755 tests/overlay/100
 create mode 100644 tests/overlay/100.out
 create mode 100755 tests/overlay/101
 create mode 100644 tests/overlay/101.out
 create mode 100755 tests/overlay/102
 create mode 100644 tests/overlay/102.out
 create mode 100755 tests/overlay/103
 create mode 100644 tests/overlay/103.out
 create mode 100755 tests/overlay/104
 create mode 100644 tests/overlay/104.out
 create mode 100755 tests/overlay/105
 create mode 100644 tests/overlay/105.out
 create mode 100755 tests/overlay/106
 create mode 100644 tests/overlay/106.out
 create mode 100755 tests/overlay/107
 create mode 100644 tests/overlay/107.out
 create mode 100755 tests/overlay/108
 create mode 100644 tests/overlay/108.out
 create mode 100755 tests/overlay/109
 create mode 100644 tests/overlay/109.out
 create mode 100755 tests/overlay/110
 create mode 100644 tests/overlay/110.out
 create mode 100755 tests/overlay/111
 create mode 100644 tests/overlay/111.out
 create mode 100755 tests/overlay/112
 create mode 100644 tests/overlay/112.out
 create mode 100755 tests/overlay/113
 create mode 100644 tests/overlay/113.out
 create mode 100755 tests/overlay/114
 create mode 100644 tests/overlay/114.out
 create mode 100755 tests/overlay/115
 create mode 100644 tests/overlay/115.out
 create mode 100755 tests/overlay/116
 create mode 100644 tests/overlay/116.out
 create mode 100755 tests/overlay/117
 create mode 100644 tests/overlay/117.out

-- 
2.17.1

