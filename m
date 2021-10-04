Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF7E8C433F5
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Oct 2021 13:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4759611CA
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Oct 2021 13:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238064AbhJDNr1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Oct 2021 09:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237253AbhJDNrY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Oct 2021 09:47:24 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED61C0D942F
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Oct 2021 06:07:36 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id p13so36502079edw.0
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Oct 2021 06:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=3xhITpFaVUHg+5EZbnzqRDgQ6Md69G0yDI6FlhB0FOw=;
        b=F09w7RiqYBXkBGwnr5At93zYHtIIKiPh9AH8Nske5mly8osqqUGbxfHK6/LPXY/IiT
         pp+L1qFfadseFfdgpRGkE6oYl0AuMP99FYtFEg7h6CGYyJiC3RnKG+dpKOe8l8LFu/6K
         /whJFAdnSpWimFCLDY1wpG4cb/JHnLybJqc/c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=3xhITpFaVUHg+5EZbnzqRDgQ6Md69G0yDI6FlhB0FOw=;
        b=cGPAWnziFck1UiGl4Wb7PJWJi5tBDzvpggrTQlUKR+NYhZNX+B6VCSB8TfLeBvtE5e
         uwd36Gjr0VVfzgzN4l4fRiM4GeVUsFAf0z0OEb23JD5j9lNgQVUPinUTfG+38wNsYEki
         qDpePpEdV9xXJFw7OGQw6suMAhFJFeUdlMh+DkX1nuQk2xcz7NJSecVdMOeFXZXtcLY5
         YX3lAC8VoRgYocUfjYe6fsFwtNuZAwMQ4CJcDMUm9c0k/TjnLZ15kZ8naGO5lC7by2oM
         5n8TxOkZENGqI8AXa6fzzTEd5oZw8vs8my3bz2xTOGHIsOsh/0let8OrtxpJBfihaxK3
         DFfQ==
X-Gm-Message-State: AOAM530jr2K7p547syYYsg+5RZAEZ6bBBtWcwQ+I68klA+at6vP5g8wm
        5cRMxRmZi46oMuTf8tGgkO/7Mw==
X-Google-Smtp-Source: ABdhPJzmLt8RhT6JUaun/XGi1pRU4pNkGD1tiuHSoPjE5/52CHX5cEIi0LfauFOPb6Eos79FMQH7uw==
X-Received: by 2002:a50:d84c:: with SMTP id v12mr17688714edj.203.1633352839921;
        Mon, 04 Oct 2021 06:07:19 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-16.catv.broadband.hu. [86.101.169.16])
        by smtp.gmail.com with ESMTPSA id d17sm2957548edv.58.2021.10.04.06.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 06:07:17 -0700 (PDT)
Date:   Mon, 4 Oct 2021 15:07:14 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs fixes for 5.15-rc5
Message-ID: <YVr8grJWnLDcBZFJ@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-fixes-5.15-rc5

Fix two bugs, both of them corner cases not affecting most users.

Thanks,
Miklos

---
Miklos Szeredi (1):
      ovl: fix IOCB_DIRECT if underlying fs doesn't support direct IO

Zheng Liang (1):
      ovl: fix missing negative dentry check in ovl_rename()

---
 fs/overlayfs/dir.c  | 10 +++++++---
 fs/overlayfs/file.c | 15 ++++++++++++++-
 2 files changed, 21 insertions(+), 4 deletions(-)
