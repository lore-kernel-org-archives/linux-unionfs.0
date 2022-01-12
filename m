Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0F4C433F5
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Jan 2022 18:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243329AbiALSeD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Jan 2022 13:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241631AbiALSdY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Jan 2022 13:33:24 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE67C06173F
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Jan 2022 10:33:24 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id k30so5835813wrd.9
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Jan 2022 10:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=message-id:subject:from:reply-to:to:cc:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=cItObkGhx2j1ERosWlqAHI53phetDWNKPiMkHtrZZQ4=;
        b=Bt6S1do776c0yXzK8UUtayqN2lcbkUsbpH3egjKaKPP4pgojzZkPY07CxfGP5Cilaa
         elf2jd9w8jzeqGEakYeINWhO/awAEIftTc+/3IQWMRz4g3xHgNUj/Zn8gP0/amRQOcUY
         I+8OdFZgYahlZMWh4P3DAOx3lJnfAhVR4OrohI5mxnUTKkQ+n+TWXdt28kogR94OjOPE
         EB2y19KIFPZwBBBWI+eh1QhQjDeFcW2EZ47SmXzO0PWeiceTbJSCnsDQIidRWgDg5sDF
         VDGYyHoOEOk9w96JMA/iqv3ADM5m4/T83m/p3+A9taDk946cBHuj9iIoyUegPgGtaKCQ
         lm3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :user-agent:mime-version:content-transfer-encoding;
        bh=cItObkGhx2j1ERosWlqAHI53phetDWNKPiMkHtrZZQ4=;
        b=g30o+/Yamp5m46ZD4c7vnjl9uOmj/E+gdgi2A9LeLo7QHo5c+E3IgHxm/khTcRthjG
         6xUOfKlcNLkVs4dO3Q3LaF5XneD8HYnkU6bv3nuDngrm35OCZ+uZyLz7dl1UTHJTcfbm
         AqYh0JkxeJ0Q8mfOpFgwwfmqPUeJAf5TNBtTW1W3R1sH38q4MvJtFEuR8SYzFgNfrFnL
         byl/Ybs34PLNlBc19QUuOLYX/zgLoBCBKNIyWU85nT6ga+9Vwt/laip7SHD58rp4yDMY
         CQJIba9+PlQogpsXDvmt0d4IkBYKvI2qbn0lA4l1N9+vL6HMrT1gyxKolBqByOi1O4Rv
         KRfQ==
X-Gm-Message-State: AOAM530c5YbO+sc3nc86UVnncSq9fPlEGjb0KiVwyqM5NEf658YG3cK6
        rDqJLYS986QJqB1dbo6VvL4ioZmxYwY=
X-Google-Smtp-Source: ABdhPJxmMZx7F+HcWU7Fg/u8fpspAW9bCRm60nVy/qIPetehvo+9iugEDt0aMwd2ZhnLDpV+p9na/A==
X-Received: by 2002:adf:eec5:: with SMTP id a5mr845354wrp.125.1642012402740;
        Wed, 12 Jan 2022 10:33:22 -0800 (PST)
Received: from mars.fritz.box ([2a02:8070:bb0:8700:3e7c:3fff:fe20:2cae])
        by smtp.gmail.com with ESMTPSA id m17sm5307007wmq.31.2022.01.12.10.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 10:33:22 -0800 (PST)
Message-ID: <10d8ed194b934c298713ad7f0958329b46573dd1.camel@googlemail.com>
Subject: [PATCH] ovl: fix NULL pointer dereference
From:   Christoph Fritz <chf.fritz@googlemail.com>
Reply-To: chf.fritz@googlemail.com
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Kevin Locke <kevin@kevinlocke.name>, linux-unionfs@vger.kernel.org
Date:   Wed, 12 Jan 2022 19:33:21 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This patch is fixing a NULL pointer dereference to get a recently
introduced warning message working.

Fixes: 5b0a414d06c3 ("ovl: fix filattr copy-up failure")
Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
---
 fs/overlayfs/copy_up.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index b193d08a3dc3..347b06479663 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -145,7 +145,7 @@ static int ovl_copy_fileattr(struct inode *inode, struct path *old,
 		if (err == -ENOTTY || err == -EINVAL)
 			return 0;
 		pr_warn("failed to retrieve lower fileattr (%pd2, err=%i)\n",
-			old, err);
+			old->dentry, err);
 		return err;
 	}
 
@@ -168,7 +168,7 @@ static int ovl_copy_fileattr(struct inode *inode, struct path *old,
 	err = ovl_real_fileattr_get(new, &newfa);
 	if (err) {
 		pr_warn("failed to retrieve upper fileattr (%pd2, err=%i)\n",
-			new, err);
+			new->dentry, err);
 		return err;
 	}
 
-- 
2.30.2


