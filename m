Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C543C433EF
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Feb 2022 14:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238985AbiBAONB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 09:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237342AbiBAONB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Feb 2022 09:13:01 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A817BC06173B
        for <linux-unionfs@vger.kernel.org>; Tue,  1 Feb 2022 06:13:00 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id n10so34517765edv.2
        for <linux-unionfs@vger.kernel.org>; Tue, 01 Feb 2022 06:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=XyLAKYKv+36v1cINNVMgxYGEEzdg72jpxZMeKa5/b0s=;
        b=m4QMQeazYsI+lIDAQho/G/Vmu17g+Ws1+rWmwV9GxXnD6Cdkjz2hJwz00ruQRU6cY0
         6qV4Pjy9OeWupBONX1cBibejcobvXI3USWZov1EJr2X62vTbsL0np2ojN2ylrwc+uja4
         SB661pV66hpB1PTsyDFWxIFDVilKpmZz1+sds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=XyLAKYKv+36v1cINNVMgxYGEEzdg72jpxZMeKa5/b0s=;
        b=dnxJ2sZXydRuOVB0acOnoc+VxVa06smb1tuaP7wRgpiyTSSgsuDOyZnp64L2U29zuT
         x0qRlv9wBYEBBoKBhoa/h+u/gSFS5SDwVTGLfpwQ61Bbs/4fkq5mdb120iMSZ9GUt8pB
         nqMRtISxkSl5Z3/nithqNnXsFWRha0ZXVY1vxyZZB+yhyVIoQFSXUN/FSzXtpa5lCJTz
         BRJ+IPmY2Rx9bMQzeEqpFao4t9puaQoXn0QDCaEnd9LOQuP+cTxFqoKNbOy7mZaIzD31
         6VnrZA2LdLrMFZyldCeEz9Qaku7m36d3oi0by6o/Sl/OEDRsGmEYaf1Vk7JLeGk5KWjK
         aMag==
X-Gm-Message-State: AOAM531kCjlog/3eiECEbRS/+puU/k/WmBHVB/XhFPt0OBedCB9XjuV3
        R3NtXNpvyxdOj7arm9zINM1aNw==
X-Google-Smtp-Source: ABdhPJxs8fIY+5a2IIeuav3WjdrGS/bZJ4rtcK1Jjck7TOBkHDNvl4RDgUfkvyXuc0npEJngiWNpHw==
X-Received: by 2002:a05:6402:1601:: with SMTP id f1mr25269020edv.165.1643724779166;
        Tue, 01 Feb 2022 06:12:59 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (catv-178-48-189-3.catv.fixed.vodafone.hu. [178.48.189.3])
        by smtp.gmail.com with ESMTPSA id s9sm19503596edj.48.2022.02.01.06.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 06:12:57 -0800 (PST)
Date:   Tue, 1 Feb 2022 15:12:55 +0100
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs fixes for 5.17-rc3
Message-ID: <Yfk/5lIpC2jC9P7F@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-fixes-5.17-rc3

Fix a regression introduced in v5.15, affecting copy up of files with
'noatime' or 'sync' attributes to a tmpfs upper layer.

Thanks,
Miklos

---
Christoph Fritz (1):
      ovl: fix NULL pointer dereference in copy up warning

Miklos Szeredi (1):
      ovl: don't fail copy up if no fileattr support on upper

---
 fs/overlayfs/copy_up.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)
