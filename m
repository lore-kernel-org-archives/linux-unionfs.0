Return-Path: <SRS0=Y/ci=AG=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A336C433E0
	for <linux-unionfs@archiver.kernel.org>; Thu, 25 Jun 2020 08:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA4CF20789
	for <linux-unionfs@archiver.kernel.org>; Thu, 25 Jun 2020 08:35:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WBDzHrzo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389894AbgFYIf3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 04:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389497AbgFYIf3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 25 Jun 2020 04:35:29 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0857CC061573
        for <linux-unionfs@vger.kernel.org>; Thu, 25 Jun 2020 01:35:28 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id k1so3416411ils.2
        for <linux-unionfs@vger.kernel.org>; Thu, 25 Jun 2020 01:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Po3yu/LP0JAh5uC4zUBtFBbOcS+lpt4fOm5gs6YNEk8=;
        b=WBDzHrzoKIIm0XdSSH/bhbOEpVvipf0v5+kx4XPFvf3ebVkZgWrtHWFTbHr4NnnrPp
         Rpw21KyhDHG0mD4igltb/vArBItOm1Rvd760RijjkByGzRg0dP1YMDNqJi9+J3BBOJ3q
         vbFyaUNMIqKDSTIOt8Cm5N6RvWXeHEitfv10t7JHPwHa9CpdsvXyOWJdWqWoFlS5XDvC
         7LhbU2SEWrsROnLgZ9bmJlKBCTutd57smxvN7hfx0SBhCM7sFecnRlgWkXSDBZ/yau2k
         rEoz/J4YeztWh1V/V0gBcPMcxU1sZwyWgm6jWEVnG4xDoReDcc29cbTs8TAkER7crcHD
         StBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Po3yu/LP0JAh5uC4zUBtFBbOcS+lpt4fOm5gs6YNEk8=;
        b=Lu8lFKYi7kWS9XJvCSls1da0WEz2nDg+V3uqNdb6O2cxApx0FEWyLAc/oRg9jPZvl8
         ohm10SWZq9pO8VaLE/hXeaAoIbRR0EagRYc/KGk6VGcM4qdC83rqHqcPL0AjsJj0TR4D
         Ks1Y/obt4zuOqW0rQm4k5rW9xeecOCbCrCPbbYpkUJsI+3t8q0p45D0fpGt/WIVNcNZK
         Ic2364/11He9vTuTtMvtZccnj7Heot+LKlJUCXPrs4GTY0rwnbvmoi2cdPIwNlmchMtX
         9/GbL+aNEGYkBAG5A6OqCgIkSJCwDKfNSubfKvkVIOtbohuOrOQzES15UPkJgq0YiumY
         6KpA==
X-Gm-Message-State: AOAM530u29+2Yc7ZlxlkRIsf2+hymb6b9RDvZsl4HAKfZ81hzi7F8Vzz
        ybNgyRSLEwzEIVD3uHqaMkySQnwR0YymALnQorW4GU5N
X-Google-Smtp-Source: ABdhPJw3DMq32ZUW/b9Qfwcq/AQvSAiLPU6k0zIFenxV/FQW6KaE0+kHqU7w52CqrXD3W0WqBLFf0tLYw4fEkUhqutU=
X-Received: by 2002:a92:2a0c:: with SMTP id r12mr31845900ile.275.1593074128265;
 Thu, 25 Jun 2020 01:35:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200624102011.4861-1-cgxu519@mykernel.net> <CAOQ4uxi53CzBwXxygKMhDDSaGpX0CcfV6jiaKRFVbrFHW7PbxA@mail.gmail.com>
In-Reply-To: <CAOQ4uxi53CzBwXxygKMhDDSaGpX0CcfV6jiaKRFVbrFHW7PbxA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 25 Jun 2020 11:35:17 +0300
Message-ID: <CAOQ4uxh9gzdRJp4g1yjQy9nDMASdsdvkzBGhGL2_+3rOBJZFAw@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix incorrect extent info in metacopy case
To:     Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 24, 2020 at 3:53 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, Jun 24, 2020 at 1:23 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
> >
> > In metacopy case, we should use ovl_inode_realdata() instead of
> > ovl_inode_real() to get real inode which has data, so that
> > we can get correct information of extentes in ->fiemap operation.
> >
> > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>
> looks right

Miklos,

Not related to this patch, I noticed something that could be odd with
ovl_fiemap().

When passed the flag FIEMAP_FLAG_SYNC, ->fiemap() will trigger writeback
of lower inode pages.

This behavior is border line for overlayfs.
I did not check if filemap_write_and_wait() ends up being a noop on read-only
fs or if it can return an error.
Following ovl_fsync() practice, we may want to silently drop the
FIEMAP_FLAG_SYNC flag? but that could result in unexpected results.

Am I overthinking this?

Thanks,
Amir.
