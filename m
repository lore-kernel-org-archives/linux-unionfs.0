Return-Path: <SRS0=Uqc0=7C=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A874C433E1
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 May 2020 14:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B177205CB
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 May 2020 14:25:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="UXPruK/n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgETOZp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 May 2020 10:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728369AbgETOZl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 May 2020 10:25:41 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E50C061A0F
        for <linux-unionfs@vger.kernel.org>; Wed, 20 May 2020 07:25:40 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id f13so2642606edr.13
        for <linux-unionfs@vger.kernel.org>; Wed, 20 May 2020 07:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=wMA33dnba4I1xySChm1PiZx/HzxTpqEY+2IJD7PaIUo=;
        b=UXPruK/n94mCL0Cf+r1Ubc53NG+qGqAjJZ3m1rxiheqyt+TgR43B2MZbM3G5oGBvzH
         AOmqtTnWkh5iqqbiEkcBoF/eGI9s12ijRF5DSEFdXYqldqojRK/RtnCu58WVNOX+2pRm
         wgliTMuFTtUZrWBUOF9mxC0NFJq5ZwsahXtew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=wMA33dnba4I1xySChm1PiZx/HzxTpqEY+2IJD7PaIUo=;
        b=H5+P4a7IPZoOhtvp+SyShRddqm40sKEqnIaHhYhcq/e8rWcmA2yP84P2YxQoPbSAd2
         6tA8Ey+/mXbfbj7VhT2N8HrumwBZEVrfoKfuv7DcIebQo2bXg+imQFo/kJytHZ1dQ8ED
         iJR6tvmlDd5eW/ulwIx3IBK/yaubFsqPtKR3hZCgyNFXueyHZzh9LIH1cXrO1QcnLHy5
         rxzmSGUmwe35IEwtP5lki2imWo880iSEGFqkiYaeZ1hyG4gnoY6UncAbNvVKFWPFA9PL
         tZ3Ys/yBK0oPpPJIq3oOl2A1ObdFR2LxY4ycRPdtLOHYLSEtGUhfL6iDi/uo7RLV0BPo
         mszw==
X-Gm-Message-State: AOAM532J6k6fny/QeLqS8QIJtm4EFPAjW/k873wM+wS+yGZHT+e4q3GP
        +qKxyrW7hUyDcP2JNPZ0Frew4Q==
X-Google-Smtp-Source: ABdhPJy10hSN7EIWDkG1mJa1W1U+NkhQqewSXt1VJ7mXWUfgHVHzkudGM39RqPLVe4KIr1tJs9kLSA==
X-Received: by 2002:aa7:d042:: with SMTP id n2mr1976267edo.226.1589984739557;
        Wed, 20 May 2020 07:25:39 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-212-96-48-140.catv.broadband.hu. [212.96.48.140])
        by smtp.gmail.com with ESMTPSA id o18sm2029759eji.97.2020.05.20.07.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 07:25:38 -0700 (PDT)
Date:   Wed, 20 May 2020 16:25:37 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs fixes for 5.7-rc7
Message-ID: <20200520142537.GD13131@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-fixes-5.7-rc7

Fix two bugs introduced in this cycle and one introduced in v5.5.

Thanks,
Miklos

----------------------------------------------------------------
Dan Carpenter (1):
      ovl: potential crash in ovl_fid_to_fh()

Vivek Goyal (2):
      ovl: clear ATTR_FILE from attr->ia_valid
      ovl: clear ATTR_OPEN from attr->ia_valid

---
 fs/overlayfs/export.c |  3 +++
 fs/overlayfs/inode.c  | 18 ++++++++++++++++++
 2 files changed, 21 insertions(+)
