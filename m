Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722C6C4332F
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 06:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjKNGtH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 01:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjKNGtG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 01:49:06 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4972CD44;
        Mon, 13 Nov 2023 22:49:03 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-40839807e82so30439825e9.0;
        Mon, 13 Nov 2023 22:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699944542; x=1700549342; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dbLcQcXRXl+GZqKFcttbgZd+9KRYVjr+8TYqlGbLba0=;
        b=a3pvmqh9/P7+zcodssdpYMWM//IgAVIQrCB+omDZR/GRdFAV56GOPcOJs6HamPSi+q
         MP/Do9VS2iQyDVRcYj/can5ZfF8znsYuQ2GRUmwIXdwAjgRet6TvIis0fMxBtFy0Rqxg
         yp9SVNwCYBRuwAyazT5AFHXgkzgatwqEaUqMio2fVVVmZ3327RY7iDK1I9NuSvNKEntD
         308H3dvMg9N+SgNnfRH9e0D/0ufUe5zGII57otnPWUMa8oS0flheC9wRQw1PAsYJPTh2
         +DZJdWOA892L2tiWDHTbU7xDQ9kbm5iNEH+akq9nqCnepP9/DynP7rJSH2UwmSzo0H2Q
         LAtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699944542; x=1700549342;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dbLcQcXRXl+GZqKFcttbgZd+9KRYVjr+8TYqlGbLba0=;
        b=wq1DM50ZoQASuWpuyTMoj/u1BsiVMtUVIqU/Rq51PLI+T4FBwmU6Ct1rHNnHK82z65
         zOWrGoLgY956dLzc8m8GasO76c+EQ2joznaJegR91Mmz0dYYIjkhSoXEge/o8/kTHc5q
         b5BScwU+Sekd42kbJCbiSCByLKhfCmLWTOWj9Od7urTOGERU9jj37MTPNyz8s1EJMkJw
         oYBdRBgEw8Qi+FbanrQN1XHnn/2jk4+ghXkh9qOr5YopsJsPegA+Yk/+BSYZhABbsVt5
         V7qaT1kKpKuG1aciovNf1imnIhHyhG04x8nzOHdX/EgWaulyoh6lA81UcyvE/dXCCwMk
         iTSw==
X-Gm-Message-State: AOJu0YyGbr52NVHA+OVzSwon5WQKZW3d7IAYhQvlS9sC61HpgiPrmuwe
        Q4f3zbCuajPAaijT0iknukUxcRi93eY=
X-Google-Smtp-Source: AGHT+IGl4m/oTkDeh7saR7fGHorOFzdJvuAE2rQOl3wCR6wmQ80OhqaLisGN9lDSav5JsvBis5j6Lg==
X-Received: by 2002:a05:600c:4743:b0:405:3924:3cad with SMTP id w3-20020a05600c474300b0040539243cadmr1296093wmo.15.1699944541355;
        Mon, 13 Nov 2023 22:49:01 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id p17-20020a05600c469100b004064e3b94afsm16338917wmo.4.2023.11.13.22.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 22:49:01 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Alexander Larsson <alexl@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 0/4] Overlayfs tests for 6.7-rc1
Date:   Tue, 14 Nov 2023 08:48:53 +0200
Message-Id: <20231114064857.1666718-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Zorro,

This update contains 3 new overlayfs tests for new features added
in v6.7-rc1.

overlay/084, written by Alexander, tests the new nested xattrs feature.
overlay/{085,086} test the new lowerdir+,datadir+ mount options.

overlay/086 was partly forked from overlay/083, but overlay/083 is not
sensitive to libmount version, because the escaped commas test is not
related to any specific mount option, so it wasn't copied over.

All the new tests do not run on older kernels.

Thanks,
Amir.

Alexander Larsson (1):
  overlay: Add tests of nesting

Amir Goldstein (3):
  overlay: prepare for new lowerdir+,datadir+ tests
  overlay: test data-only lowerdirs with datadir+ mount option
  overlay: test parsing of lowerdir+,datadir+ mount options

 common/overlay        |  27 ++++
 tests/overlay/079     |  36 +++--
 tests/overlay/084     | 169 +++++++++++++++++++++
 tests/overlay/084.out |  61 ++++++++
 tests/overlay/085     | 332 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/085.out |  42 ++++++
 tests/overlay/086     |  81 +++++++++++
 tests/overlay/086.out |   2 +
 8 files changed, 735 insertions(+), 15 deletions(-)
 create mode 100755 tests/overlay/084
 create mode 100644 tests/overlay/084.out
 create mode 100755 tests/overlay/085
 create mode 100644 tests/overlay/085.out
 create mode 100755 tests/overlay/086
 create mode 100644 tests/overlay/086.out

-- 
2.34.1

