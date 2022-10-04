Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ACA1C433F5
	for <linux-unionfs@archiver.kernel.org>; Tue,  4 Oct 2022 10:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiJDKev (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 06:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiJDKen (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Oct 2022 06:34:43 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01789B11
        for <linux-unionfs@vger.kernel.org>; Tue,  4 Oct 2022 03:34:39 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id a3so8376727wrt.0
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Oct 2022 03:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=C9FzVkEhDqWvyijrZNnPTbX6byLMU1z8gsP9/cp/X48=;
        b=X1kEOOGsMlCIy26RnvZaMj+5Ey6NBH6zXPW4nKgk22zD/ReYUdrxHyp6SExrrqae1I
         /Zq0N5Ulwz6tt6iHUFH1d2EXoxN1Y3KUJKrAhVr2Ly9IjU1mrBggpaNY4LIBRvK0dHYw
         AzqQdmOSTKORJduc/+yF72oTZZfL0Gj5CNKtCLiu0JrMx8cfMivW0skkS6Ct4mRQdUm8
         76Do/6tKUto7g7RVzKXm1ucxJtWyk1ww7cJf/51P3TeYQ5xKsrspwH5cFAdZ5aYmIFXE
         UzJClUx4dMueWdsxYpvrv0JyRpsDpsZuUgOrinSefo1XREtPRXX4O/VALmVIHdlUTAkb
         N2+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=C9FzVkEhDqWvyijrZNnPTbX6byLMU1z8gsP9/cp/X48=;
        b=bja0EYn0BdTWamctBqA8wSP5pLPC7kQx0Zthi1SEgoek5DW0aX084uQjrur5A6DNop
         MIByk4k4rPA3kTyK97Ei3lxkOJMSG9Q0kO/ODD61swPl8KyRb9RFbXYfGJA6N4AXFn1p
         NS2GbdNSt6B5SS50cV2wORTwcl0JJ8Y4UkGuj/SFEgVwqVcGh3XU4C+NM4MmKts4HcDB
         Ym3vxm/egXoSBOUXWbKvTlTVx6KbxvIgolMxVmzn7fftHM9J8xfKNduaSuH+gcysOpsB
         MMHfJHDg3UDjJtPGPWDIz/kAhqLCDjOln/TeKlnENVoq0OAE6gnfegRNVtg5BkSldCRT
         pSLg==
X-Gm-Message-State: ACrzQf0zHf8GWpAOLH6KYRWH6UmjWR9z24Dn9YtoiVrX7suEBwwvbv/A
        A/yUYb9fvG51fbfY5OSn92Ry+zgbCTY=
X-Google-Smtp-Source: AMsMyM4Mm0ie9ioa/LI6P+Gz0Lox7YU1/lIV1Qk2E7z4a/7cUZJ1ZQQNjOfZshWTGBx/NU8ZPFYeTQ==
X-Received: by 2002:a05:6000:982:b0:229:79e5:6a96 with SMTP id by2-20020a056000098200b0022979e56a96mr15469210wrb.469.1664879677475;
        Tue, 04 Oct 2022 03:34:37 -0700 (PDT)
Received: from localhost.localdomain ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id b14-20020a05600c4e0e00b003b535ad4a5bsm14691726wmq.9.2022.10.04.03.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 03:34:36 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH 0/2] Performance improvements for ovl_indexdir_cleanup()
Date:   Tue,  4 Oct 2022 13:34:31 +0300
Message-Id: <20221004103433.966743-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos,

I ran into an incident of very large index dir which took considerable
amount of time to mount the indexed overlay (~30 minutes).
The index dir had millions of entries and I do not think that the use
case that caused this is typical.

The following two patches are based on perf top analysis of this
incident.  I do not have access to the data set that caused the
very long mount time, but I tested the desired CPU usage improvements
on a smaller scale data set.

It is hard to say if this extreme case of very large index dir is
common enough to be worth any attention, so I did not tag the fixes
for stable and I don't think it is urgent to apply them.

Unfortunattely, the investigation of the incident was not timed
optimally w.r.t. to the current merge window.
Nevertheless, the changes are quite trivial, so you may want to consider
them either for -rc or for next release.

Thanks,
Amir.

Amir Goldstein (2):
  ovl: do not reconnect upper index records in ovl_indexdir_cleanup()
  ovl: use plain list filler in indexdir and workdir cleanup

 fs/overlayfs/export.c    |  4 ++--
 fs/overlayfs/namei.c     |  7 ++++---
 fs/overlayfs/overlayfs.h |  3 ++-
 fs/overlayfs/readdir.c   | 12 ++----------
 4 files changed, 10 insertions(+), 16 deletions(-)

-- 
2.25.1

