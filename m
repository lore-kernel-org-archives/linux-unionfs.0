Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C68AC41513
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Aug 2023 15:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbjHPPYW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 16 Aug 2023 11:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344188AbjHPPYE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2023 11:24:04 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B7E30C8
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:23:40 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-319559fd67dso5049026f8f.3
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692199419; x=1692804219;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2vRcvqoglDAInVQTFSv3mT+AQSO384XAMX6heNEsjTA=;
        b=AiFYAsKMcP2SNDla9fh3mE7+zJL9OAAJdqVvsCOqCYq8CnIzN6zuxLO3qv1lPBbCDL
         N9Jo4Tj+B9aSWvy8hoWTcY9v4sG9hmUHdQDCtssx9vrA+2gY8DcRSI1WWpg4O0HAfDWn
         k4Y3EOXCpLiTv2Www7r+h/mSQE8gjzez9n9c7/OR78lwo1ciUON08ciUQqFpKcFrSaRU
         m6VhkHlVoAXwGCFxRWwLXnWDMT8xyDKgaE+6bFBChSBGy+QDVpq4zgGeriiMYpk12/jw
         ZNFYMvH57MaVIrJbwoUTWn2JKxi3ppQxxc97KZbNXJW3IS9kJ/kVPok+MGuxWn9f8E+G
         aGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692199419; x=1692804219;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2vRcvqoglDAInVQTFSv3mT+AQSO384XAMX6heNEsjTA=;
        b=BOUWnyFRhDgQG8aVczCCQpxIGA0/4f66x9higENjY/5HLiv4kJIdrlmhCCeJH7+erf
         WroJnDcF0HftymiZd8OYM/D5dc8sZbNEkJUX1IgFYM4NS1rP6agVIjx+h4JQb9P94Xki
         RGufxaE86tyG+eB2RAXqDSTIQxHpooHaJHgvy655XHUG97y/FspN9gzzX9vhLDiI7OcW
         HnbbAHks7L4Wc80nMxiEAvySBoAe5NeDyJDFQWatC1NN8xDsM1py/gip9hsZ8Puoo/db
         Mvh04iLfzhaW33y0oGb63PEMWMjEejF9Kp/sLi0HPraKcaSGTKozdRhsjVC3vfgE9k85
         0Xsg==
X-Gm-Message-State: AOJu0Yy+aRmlTm7Ugme1W9KgW+bI3CM7ltL8XhONtxZLqVwdQjJkULwb
        7PzaFxLuPD7GKwaIr5jZJrwM4kc8NgI=
X-Google-Smtp-Source: AGHT+IH5eQ4B98mN2Fk+s6L8xX+c4KPUueij3ekVx3KPL/ZsGzKC3Szc8VKUWLZtZbzka9Lq7XvUxA==
X-Received: by 2002:a5d:5507:0:b0:315:a1d5:a3d5 with SMTP id b7-20020a5d5507000000b00315a1d5a3d5mr1973022wrv.22.1692199418640;
        Wed, 16 Aug 2023 08:23:38 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k7-20020adfe3c7000000b003176c6e87b1sm21701988wrm.81.2023.08.16.08.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 08:23:38 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH v3 0/4] overlayfs lock ordering changes
Date:   Wed, 16 Aug 2023 18:23:30 +0300
Message-Id: <20230816152334.924960-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Miklos,

I went for the less intrusive approach of holding mnt_writers
only throughout copy up instead of a long lived elevated refcount.
We could reconsider the long lived reference in the future.

Thanks,
Amir.

Changes since v2:
- Separate mnt_writers and sb_writers locks during copy up
- Fixs error handling bugs found by Miklos

Changes since v1:
- Breakup the large ovl_want_write() transaction in copy up
- Add fix to possible deadlock with encode lower ovl fh

Amir Goldstein (4):
  ovl: reorder ovl_want_write() after ovl_inode_lock()
  ovl: split ovl_want_write() into two helpers
  ovl: do not open/llseek lower file with upper sb_writers held
  ovl: do not encode lower fh with upper sb_writers held

 fs/overlayfs/copy_up.c   | 141 +++++++++++++++++++++++++--------------
 fs/overlayfs/dir.c       |  60 ++++++++---------
 fs/overlayfs/export.c    |   7 +-
 fs/overlayfs/inode.c     |  57 ++++++++--------
 fs/overlayfs/namei.c     |  37 +++++++---
 fs/overlayfs/overlayfs.h |  30 +++++++--
 fs/overlayfs/super.c     |  20 ++++--
 fs/overlayfs/util.c      |  73 ++++++++++++++++++--
 8 files changed, 275 insertions(+), 150 deletions(-)

-- 
2.34.1

