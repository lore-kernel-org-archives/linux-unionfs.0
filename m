Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCD3C4361B
	for <linux-unionfs@archiver.kernel.org>; Mon, 14 Dec 2020 23:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F69322509
	for <linux-unionfs@archiver.kernel.org>; Mon, 14 Dec 2020 23:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441153AbgLNXHQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 14 Dec 2020 18:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440571AbgLNXHP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 14 Dec 2020 18:07:15 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E004FC061793
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Dec 2020 15:06:34 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id u5so4418853qkf.0
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Dec 2020 15:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:subject;
        bh=5lwj2KnwQRaQSjZlfUliFwvsHqt11xuXe19pBc5o6q0=;
        b=Jsk+PMYshBgKrgnU6yrR6b5L4w2ojNIhsctf4/MIoDqbJ9IgJlpoJ23w7UW28peprq
         FWAoJWFd7iQdQwIDm4oeEtjBsY2ntXJaG3Nt1SmenSLPzk34SVG6AX8UISE4IQTM8Zmu
         1Y2qJiw3qtSmSB2oqR5KGAZNdqTPgaEP2NTFOpuakbs5ANP0Cxgdo2tuuYo0e07oDso+
         mitSxv/INf/pw/IdNf0oJi71gMmXTStFvnux4hyf3LumsIYqvhtcX8TxxFnNjqm3eru+
         wuGy9Be8DCP51/V8SmoUXHNagLvGV4QkqauYV/qTujm2r9ZdJh3Nan6iBBEMjB7s+0fA
         /55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:subject;
        bh=5lwj2KnwQRaQSjZlfUliFwvsHqt11xuXe19pBc5o6q0=;
        b=CGRNO52+sGxQN5LqxCzV+6/8zqiqjkkT1qF/H9041507PIv8cXA92PeSuNKDIvw155
         7nSqgiRN15b6tTnTyWpF+fBQvR/VWpHRdyD+Jz4VDH1kVYOV/CF/TffOWGH4C/cbrpc0
         qvocOU0a2eQipbwpPNVca8TSEySjBsCPu5XBBrs5jjBb6yx735X+pglrpN15XznRXli+
         DfTmBVAx8M2dQg+UzjhLYlafBJxwY5juNRq+oDLg5TY/ZJCERB5BZ4r3kbry8AsEZvYg
         X9RWgPPeHviKqTc9O4+9BWarPWWmozWaYZyC0HfTf+OaGihG1iZeZg8txmIvhM069C3i
         6c0g==
X-Gm-Message-State: AOAM532wyOZdUcm1IGsbcTwHcuuBTICrahUPOZsqBJ8qwNuJN9U2VKVA
        scJ3met+nvRnVgHzL5QAxFPLOWMFIbRaeQ==
X-Google-Smtp-Source: ABdhPJzZ15MVEYfO8G5xI/IAoLf2Hg/UA4bC8by4GJqM/hC0vutDKCGv9/lkaR1C96ErWJSBJTemAA==
X-Received: by 2002:ae9:e70c:: with SMTP id m12mr27126159qka.451.1607987194084;
        Mon, 14 Dec 2020 15:06:34 -0800 (PST)
Received: from aldarion (pool-74-97-22-49.prvdri.fios.verizon.net. [74.97.22.49])
        by smtp.gmail.com with ESMTPSA id g10sm15706643qkb.8.2020.12.14.15.06.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Dec 2020 15:06:33 -0800 (PST)
Date:   Mon, 14 Dec 2020 18:06:28 -0500
Message-Id: <2nv9d47zt7.fsf@aldarion.sourceruckus.org>
From:   Michael D Labriola <michael.d.labriola@gmail.com>
To:     linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Subject: failed open: No data available
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

I'm sporatically getting "no data available" as a reason to fail to
open files on an overlay mount.  Most obvious is during ln of backup
file during apt install.  Only seems to happen on copy_up from lower
layer.  Lower layer is squashfs (I've seen it happen with both the
default zlib and also zstd compression), upper is EXT4.

I've only bumped into this problem recently with 5.9+ kernels.  I'm
gonna go see if I can reproduce in some older kernels I still have
installed.

Anyone else reporting this?

-- 
Michael D Labriola
21 Rip Van Winkle Cir
Warwick, RI 02886
401-316-9844 (cell)
