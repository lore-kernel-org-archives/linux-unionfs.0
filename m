Return-Path: <SRS0=T6lg=3U=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 156A7C33CB7
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jan 2020 11:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEF0E20705
	for <linux-unionfs@archiver.kernel.org>; Fri, 31 Jan 2020 11:50:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hEaGR/c6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgAaLuS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 31 Jan 2020 06:50:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27253 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728440AbgAaLuS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Jan 2020 06:50:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580471417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=T2z+DkKj1ID1NxByo8HKHzT75W1sdkuwiaCsjlxgCO0=;
        b=hEaGR/c6v23mGdEHuvN/rVrFVjy1dXTxxLO2B/X9OtKSCywP498jxsv3Ic7FtW2qwj+8e/
        fW9DOenv771Lk9P2OcRcqXgvl+GGlE9qAn2yxCruYSu4uHrTi07U0XcNfk3TSGEbEoJFcu
        WYxj1MvUD/fe3O+/m6XtjM6vnGz0Zog=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-KADhinHnM8aULVSUmBHflQ-1; Fri, 31 Jan 2020 06:50:14 -0500
X-MC-Unique: KADhinHnM8aULVSUmBHflQ-1
Received: by mail-wr1-f69.google.com with SMTP id 50so2371767wrc.2
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Jan 2020 03:50:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T2z+DkKj1ID1NxByo8HKHzT75W1sdkuwiaCsjlxgCO0=;
        b=Vigs1Ppq9kiN40k1B0y0/EoTHlvvvcMn2aBzLLJHAADegUBsT3iFCxeij+avitKFhG
         hCisspWH0nIO9SIVY8hKtzhRNu+lNAQ3t8xIqnE4kvwRVJQ6OxJdc33DNe5FgA+emv0U
         O69xbo32A7F6XZ5jzYI1VdvCPyyNd2FidBjP5Dr/wyPg/U51zzvicDGqzHN5G9cYCQQj
         M4xSClp6isqiFoNrN8Vr4RLYunW+OviaFKQ3M7xfH4Q8GP6Sa56iKaBmcO6DYTyM9Qk6
         wrFgWs40890z7CEP1oc/zI0iLAVNp3qjcG0jwP3A+Y6lIH8QiqrDFn+MxU2D2D9LLGAP
         5Mgg==
X-Gm-Message-State: APjAAAVYn5sX+IQc/kdKTs6HE3zdu0rsN9VbvFq3LykqMDFEvuZ36Trd
        IXJRJFc2lIDPSRilu1Sz6jBHc3coo2GXv8v2604h8AzbJrI7L3kqfOwTSpkx+7gRTYcEJlw+wu2
        utU8bv1ikOSny7ohZrb0cHNrhMw==
X-Received: by 2002:a5d:5752:: with SMTP id q18mr12251488wrw.277.1580471413430;
        Fri, 31 Jan 2020 03:50:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqwhL9S+8NlRwy97bIb2vvtvOsoiZnCiMBm8m/dH9p2y6mxAG+gItOR9SR9h5j0QAY73ljbxcQ==
X-Received: by 2002:a5d:5752:: with SMTP id q18mr12251469wrw.277.1580471413244;
        Fri, 31 Jan 2020 03:50:13 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (84-236-74-45.pool.digikabel.hu. [84.236.74.45])
        by smtp.gmail.com with ESMTPSA id s1sm2746622wro.66.2020.01.31.03.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 03:50:12 -0800 (PST)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     linux-unionfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 0/4] ovl: allow virtiofs as upper
Date:   Fri, 31 Jan 2020 12:50:00 +0100
Message-Id: <20200131115004.17410-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The purpose of this mini-series is to allow virtiofs as upper layer of
overlayfs.

Applies on top of #overlayfs-next (commit 1a980b8cbf00 ("ovl: add splice
file read write helper")).

Git tree is:

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git#ovl-remote-upper

Thanks,
Miklos

---
Miklos Szeredi (4):
  ovl: restructure dentry revalidation
  ovl: separate detection of remote upper layer from stacked overlay
  ovl: decide if revalidate needed on a per-dentry bases
  ovl: alllow remote upper

 fs/overlayfs/dir.c       |  3 ++
 fs/overlayfs/export.c    |  2 +
 fs/overlayfs/namei.c     |  5 ++-
 fs/overlayfs/overlayfs.h |  3 +-
 fs/overlayfs/super.c     | 90 +++++++++++++++++++---------------------
 fs/overlayfs/util.c      | 18 ++++++--
 6 files changed, 68 insertions(+), 53 deletions(-)

-- 
2.21.1

