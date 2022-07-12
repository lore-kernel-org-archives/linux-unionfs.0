Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F02CAC43334
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Jul 2022 13:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbiGLNbf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 09:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbiGLNbe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Jul 2022 09:31:34 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D5EB6292
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Jul 2022 06:31:32 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id r6so10100638edd.7
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Jul 2022 06:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=hPJjqua15ah0sn3T7jWS+IFyxkya2Msc4Z32Nn2kGoc=;
        b=rg5QfwIufOpJub8XP1Do/yDFjwLo/4t6z3t0MVStmetmWBYwLZdVZFAfcHoRgYuULQ
         dhca7EmYKW/nyw6Emq5yMl47pmsCvL5eqqRyQjI6t+cTZL46Rqp67OGPqy7T1nBYdMAc
         EjhvJ817SyhMg+YYsqMuMFZA3gyJyQl0gJC3o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=hPJjqua15ah0sn3T7jWS+IFyxkya2Msc4Z32Nn2kGoc=;
        b=qdq4GqtNTeHBzjmcShzmjJPWXairf7BT6ejR2UGc1JkpQTnSrNoSDzqlHXZ1fVM12r
         6wOmsg7E6U2jxpZPvQbUFN2StrjfFYKsIrncw5Oqte9JaUy7/vroDKAaXyIfwYZb22Jw
         EeVxXvy0wA5iFj8FIqh7x85fh9694DpwBghFP14TY4m3FnrCIbkDFTST18CaXpUrMXDZ
         HLb6qS8y3iVWPqItIiRQFN2alK0jChZ2ILSXrcImGp5mR6vhLo3dYjPkkiN+x1d5U1fJ
         QplaG/BZWrff/c2nBa+Tu5DbP/PKgyVhPPjeaVQ+OPteoSd8lfYF7X5C+ma9nZsGKxal
         GE9Q==
X-Gm-Message-State: AJIora9SqutEuoMBi9kkT9kgYfbpEhaIpqBrvKnumVFxPAudrnwpCmH3
        gwQ6otPX3DbEULum9KvoDpD1ga1W/5Dk3FFh
X-Google-Smtp-Source: AGRyM1usO+07EFR5sCIZbvQcc/IsObDEBI0KLY3SELHUhBKsdOKF7QwU9BBoz3qsp+Ku7g593e0m5A==
X-Received: by 2002:a05:6402:5201:b0:43a:d797:b9c with SMTP id s1-20020a056402520100b0043ad7970b9cmr13125486edd.343.1657632690892;
        Tue, 12 Jul 2022 06:31:30 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (82-144-177-44.pool.digikabel.hu. [82.144.177.44])
        by smtp.gmail.com with ESMTPSA id l18-20020a1709063d3200b0072af3c59354sm3850822ejf.146.2022.07.12.06.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 06:31:30 -0700 (PDT)
Date:   Tue, 12 Jul 2022 15:31:24 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs fixes for 5.19-rc7
Message-ID: <Ys13gTA+irEuI+OA@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-fixes-5.19-rc7

Add a temporary fix for posix acls on idmapped mounts introduced in this
cycle.  Proper fix will be added in the next cycle.

Thanks,
Miklos

---
Christian Brauner (1):
      ovl: turn of SB_POSIXACL with idmapped layers temporarily

---
 Documentation/filesystems/overlayfs.rst |  4 ++++
 fs/overlayfs/super.c                    | 25 ++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)
