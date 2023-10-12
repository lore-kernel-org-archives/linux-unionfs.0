Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 811E0CDB47E
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Oct 2023 13:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378971AbjJLNon (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 09:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378980AbjJLNom (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2023 09:44:42 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503DEC6;
        Thu, 12 Oct 2023 06:44:39 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-406618d0991so10125465e9.2;
        Thu, 12 Oct 2023 06:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697118278; x=1697723078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hOu+ioq+TirtMxJ+BaI2PKvCmkWg65munbmrrDQrxOk=;
        b=R5Dnv/Vv3rift11mwskQ31zLSXAGXJJOsqcKW6SVDHhETxQ3h/gOzoQwEQwzY+FLJH
         aR/S7s5mQS4FkX0m7oNIYEpf2KiOxDZXgXfXazmWwq3Cynn/EppnGTH6yUsLCElMvIys
         K+jS/G04WkqlTHKU+X+9P8LRHs8jKclpRgCX2NsfnjAe5XcAglbUZANlie/c9TTdomVC
         BcWeFlgDY5XY6/gof3/0qZABQRK1b2GQ18LscoRteXnNaSktXe3ZbvJ84s2LwMzVXH0W
         DlbNfw4rPokrt8rkP2odEaJUcbl66/OXxoGnBvGKb4zRNaXe6O/XzCot3zF0dUXYAo/C
         7Y/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697118278; x=1697723078;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hOu+ioq+TirtMxJ+BaI2PKvCmkWg65munbmrrDQrxOk=;
        b=ldXdmjWDs346yhcbZuvcGJSvOw+vOJzPrONbfE7hXnk2Ffy2sSyT5bcuqTeypt7Q8Z
         RrfeuL1RcFCK9VNhuls/o8Lva6gI1u8tUSvtLK+EXpV4LtzxYGycOrnTqUDpKgvYMKxa
         4nSLJY9Ed1e+6yJCP8k5M4gOY8R3rBWSHko8r8PH2SCVXAeVIHTzoniBZ2jcwGbwQjZT
         m97YEFPy2wr3ZwX0JJ2XymVqXuT3VQDYMIil803oBZCP8P3+ONMBD0lz3n6X80VCb0Mv
         i5EyZH6aFqAngfMsxS1AiEQkya+K5gIW11kRrI/rf/XA9eizzRcWy8yhlOIizQ50siD0
         +smQ==
X-Gm-Message-State: AOJu0Yw3C6WoR/QL6aR3mLuOOvo6xuS23i2odS0IU/Wl/1R/PTeZmHP4
        jsGVwjiXww+PEY8igLXpCC4VvSwBA5o=
X-Google-Smtp-Source: AGHT+IHrnZER/qylP+y+n6A8ve2nocogOhAeetjkz2WSo10Ofy3nyQD2zLpZgoYASzLkOQOrHTM14g==
X-Received: by 2002:a7b:cb8b:0:b0:402:8c7e:3fc4 with SMTP id m11-20020a7bcb8b000000b004028c7e3fc4mr21502656wmi.30.1697118277561;
        Thu, 12 Oct 2023 06:44:37 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id l16-20020a7bc450000000b0040536dcec17sm21825154wmi.27.2023.10.12.06.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 06:44:35 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>
Cc:     linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/2] ovl: fix regression from new mount api conversion
Date:   Thu, 12 Oct 2023 16:44:26 +0300
Message-Id: <20231012134428.1874373-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Miklos, Christian,

I decided this was easy enough to fix with a generic helper without
duplicating code, so we'd better fix it while 6.5.y is still taking
fixed.

It looks like smb3_fs_context_parse_monolithic() could also use the
generic helper, but it is not a straight forward change, so I will leave
that to smb client developers.

Thanks,
Amir.

Amir Goldstein (2):
  fs: factor out vfs_parse_monolithic_sep() helper
  ovl: fix regression in parsing of mount options with esacped comma

 fs/fs_context.c            | 34 +++++++++++++++++++++++++++++-----
 fs/overlayfs/params.c      | 29 +++++++++++++++++++++++++++++
 include/linux/fs_context.h |  2 ++
 3 files changed, 60 insertions(+), 5 deletions(-)

-- 
2.34.1

