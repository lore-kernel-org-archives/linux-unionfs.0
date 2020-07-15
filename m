Return-Path: <SRS0=S/v9=A2=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B865C433DF
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 08:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB11D2064C
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 08:57:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="BvBdA7rV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbgGOI5j (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 04:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbgGOI5j (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Jul 2020 04:57:39 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FC5C061755
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 01:57:39 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id w6so1355394ejq.6
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 01:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S2XuaDn63KZZNxq4+MXznPLwOS4CmpDtSk72BrjI+pc=;
        b=BvBdA7rVhpKdt00vl+h+ZWhExAY/+ml8fUlmBe7zAzXWW+F+w8k+5/4FZq4gs5OSYm
         s6GJ1eI4D6ImxE9r7eHyIBN+04W+Jm1pV8hjHtB916q18QvB3xWkC0jpgNXklTJe+ef5
         ZWoJVeZBoYGFTNzErd+8QSr/LrV6Vfq3eVL74=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S2XuaDn63KZZNxq4+MXznPLwOS4CmpDtSk72BrjI+pc=;
        b=RO2F8l9Rd6iumLVMojrGY3V7d6TplFxonAICkFy0u1dQKqFDZPEum2v9bPVPRybYZD
         2jBu6AYf5fKQ/9e3ZyyxXcPlZHzcgsemNHWQP0f3vj39Csdy6p2Wq05mF0mx0KJcLIVC
         ufq+ERBlDyi81+vChJqCUbZelPN5zShPymm/T+z8ugH7Z87tt8eylCNZo0+W8VCHiwud
         l4lp8lEhtiel4g2kHTUOEZMYkLXdOmoDGG+49fPK9iB7SBJLNeK0u3wcn6Ot1am+jjt2
         xDxkVt3rC2iMNS8cUz9mdXsjG5p/Gq5FPHGlcg28zzaDqjAoX0/YP0OYata/ao7u+JLp
         Qcjg==
X-Gm-Message-State: AOAM532l0XOylrh+gsYxmEP81wB0tTamKetloDatKEY5z4PxXE9kdtKb
        F2ICxe7Q8VH48ne6d5baYhWeRaF472c6GFqfi+F7cA==
X-Google-Smtp-Source: ABdhPJyZUxUTTObzDWjcjpKSuGKgpa3ZE+whzrwKJRVPFsqUi1wj93EFGYfJAJtkLWF7KxI1DYIZCsD4Iy4y0hySoAw=
X-Received: by 2002:a17:906:4f09:: with SMTP id t9mr8206091eju.110.1594803456165;
 Wed, 15 Jul 2020 01:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200713105732.2886-1-amir73il@gmail.com> <20200713105732.2886-2-amir73il@gmail.com>
 <20200713192517.GA286591@redhat.com> <CAOQ4uxiXWH2RtXdLXRJY-pcZt=zFK-urhcTSQYNbPpmMjFCJdw@mail.gmail.com>
 <20200714134135.GC324688@redhat.com> <CAOQ4uxgGV4v+8_ziFZ0_qd9J8e=a8mzyHWcxDSE5quQ3+Wh41A@mail.gmail.com>
In-Reply-To: <CAOQ4uxgGV4v+8_ziFZ0_qd9J8e=a8mzyHWcxDSE5quQ3+Wh41A@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 15 Jul 2020 10:57:25 +0200
Message-ID: <CAJfpeguoOSvMPu7fz=EFQqr+aUsPTgKM9YuBRnH9mkc-35+Jng@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] ovl: invalidate dentry with deleted real dir
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>, Josh England <jjengla@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 14, 2020 at 4:05 PM Amir Goldstein <amir73il@gmail.com> wrote:

> Today, if a user deletes/renames underlying lower that leaves
> the overlayfs dentry in a vulnerable state.
> I do not have a reproducer to OOPS the kernel with that, but
> syzbot has created some crashes of similar nature in the past.

Can you back that up with references?

Don't misunderstand me, I'm all for making behavior more
deterministic, but I'd also like to fully understand the current
behavior.

Thanks,
Miklos
