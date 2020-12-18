Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72120C4361B
	for <linux-unionfs@archiver.kernel.org>; Fri, 18 Dec 2020 10:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40D9923A62
	for <linux-unionfs@archiver.kernel.org>; Fri, 18 Dec 2020 10:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgLRKjk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 05:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgLRKjj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 18 Dec 2020 05:39:39 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B68C061282
        for <linux-unionfs@vger.kernel.org>; Fri, 18 Dec 2020 02:38:58 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id 6so2514791ejz.5
        for <linux-unionfs@vger.kernel.org>; Fri, 18 Dec 2020 02:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rBYbGvFqZmBlkEy+MiMane5SSAMLwKtULGmRJA2FtKc=;
        b=u+EZw2S4A90QPOyd/Hn+7HNA5OHSOZe7942l5fAi14FcYSAevlbwNP6V2GJ/Oz6jig
         3kQtA+MsAEkkNS2GBfJ4T1QmRCP39TRS8bGLVw++Zv8QwRhIDuhMGoS5VIuVdHZx65kS
         wSiq7zFC+PcRCCf6R4DWNM4gxXRKthIQjO6EnInkDv2/S6N9mTn9QLWqlUgKk2X4wcI+
         5zQeBOHRv5G5Y4nHVpvN8YBKyXBrNm+7qbmUp/j1csTprQNYg8p+qjpfTpQlju+r2JC5
         AxgS2au3QNT1gjTrbwM37O86aApHEKZ+clJdvVHg8hG4GiY9O8BfPjaaCKRh6+7nUlRg
         sqtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rBYbGvFqZmBlkEy+MiMane5SSAMLwKtULGmRJA2FtKc=;
        b=QsUEat4DqrsPqBh11mVmxydsFd+zwK+jom4UwY7iwNKMqgyXIKRG8Pe7k3Kf8UhK8y
         S3Fg5Ov+7RiJQjD0uHGM4srT38QmHtQUiekEq0ov3+ihDH9jsvwgl2dWp9UTjsNnjdSU
         jiGhCUD+T1HpTu43LsrRtsrjZd/sEWA6p5s20m6AhU4rtdd5ieS4J2sPyWjAYwFJ+s1+
         9Amu1ypkDa24yQTn/GEth88LtBicXfQuevbSiK2+wpqJwpB8k6T2EzHHwcCnCDlUOarC
         5lSyITZ9eiz9ZMV1o0tfWUSYFP1Oyz3eIfpoM3YC79hqT+2R2ILIqtfSBLp5okKuxw4U
         NGvQ==
X-Gm-Message-State: AOAM532k5E436AaHYFv0Lp9pfHD18NEx3UmMwUYNQ1BRQYHElRHgse1P
        nLDx9SJ/UKprrFexG22/hsr07ZmwyGQ=
X-Google-Smtp-Source: ABdhPJwMc30LcY99OVGGvXyZlgsrijbigBcps1mRFwTQ/uyPUAuWxSROiDO1clwBRm058GNYUjmYCg==
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr3287830eju.375.1608287937364;
        Fri, 18 Dec 2020 02:38:57 -0800 (PST)
Received: from localhost.localdomain ([31.210.181.203])
        by smtp.gmail.com with ESMTPSA id d6sm5234891ejy.114.2020.12.18.02.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 02:38:56 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     linux-unionfs@vger.kernel.org
Cc:     Miklos Szeredi <miklos@szeredi.hu>
Subject: [ANNOUNCE] unionmount-testsuite: master branch updated to 95be14e
Date:   Fri, 18 Dec 2020 12:38:54 +0200
Message-Id: <20201218103854.10440-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi All,

The master branch on the unionmount-testsuite tree [1] has been updated.

Changes in this update:
- Support for user configurable mount option
- Prepare to run tests with "userxattr" mount option

The previous update brought the ability for users to configure custom paths
with a custom filesystem for the underlying layers.
That ability was used to add xfstests wrappers for unionmount-testsuite.

This update brings the ability for users to configure custom overlay mount
options. This feature is also intended to be used by xfstests [2].

I used this ability to run tests with the new "userxattr" and "uuid=off"
mount option:

$ export UNIONMOUNT_MNTOPTIONS=userxattr
$ ./run --ov --verify
TEST rmdir.py:64: Remove populated directory
- rmtree /mnt/a/dir106
OSError: [Errno 5] Input/output error: '/mnt/a/dir106/pop'

$ export UNIONMOUNT_BASEDIR=/vdf # (xfs filesystem)
$ ./run --ov --verify
TEST hard-link-sym.py:10: Hard link symlink
 ./run --link /vdf/m/a/direct_sym100 /vdf/m/a/no_foo100
/vdf/m/a/no_foo100: inode number/layer changed on copy up...

$ export UNIONMOUNT_MNTOPTIONS="uuid=off"
$ ./run --ov --verify

and came to the following observations:

1) rmdir test as well as other tests involving opaque dir are failing
   on tmpfs, because tmpfs does not support user.* xattrs
2) hard-link-sym test fails consistent inode number verification also
   on xfs, because symlink does not support user.* xattrs
3) All the other tests pass on xfs with the userxattr mount option
4) No failures observed with uuid=off

I did not try to run tests inside non init userns.
This practice is left to the reader.

Thanks,
Amir.

[1] https://github.com/amir73il/unionmount-testsuite
[2] https://github.com/amir73il/xfstests/commits/unionmount

The head of the master branch is commit:

95be14e Allow user provided options with or without -o

Amir Goldstein (3):
  Add support for user defined mount options
  Let "userxattr" mount option in UNIONMOUNT_MNTOPTIONS imply --xdev
  Allow user provided options with or without -o

 mount_union.py   |  6 ++--
 remount_union.py |  4 +--
 run              | 90 ++++++++++++++++++++++++++++++------------------
 settings.py      | 15 +++++---
 tool_box.py      | 18 ++++++++++
 5 files changed, 91 insertions(+), 42 deletions(-)

-- 
2.25.1

