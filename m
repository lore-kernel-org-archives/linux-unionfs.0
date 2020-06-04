Return-Path: <SRS0=s+il=7R=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F61BC433DF
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Jun 2020 08:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 212C4206C3
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Jun 2020 08:55:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="f+Lz97I9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgFDIza (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 04:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgFDIz3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jun 2020 04:55:29 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1E5C03E96E
        for <linux-unionfs@vger.kernel.org>; Thu,  4 Jun 2020 01:55:28 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id gl26so5180506ejb.11
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jun 2020 01:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1cyPRerltnuf6OiO7zJfaJBlJDvo/vDR9533o+NbRzk=;
        b=f+Lz97I9fYwRYsY1POv4BsWh7sUNv4BwjVfHmAFW+Z0LJmUxUd/I2VZj/A64TA7MPT
         pehLmYFlyB2KmT0oVWyHVVPADXZ4TH++UGj5eo9+51dg818r2EbyPG4wWWhVHyp98pBk
         Smrt++8CCAh/W90dkqBCeWHyBCw5gCvR/nIU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1cyPRerltnuf6OiO7zJfaJBlJDvo/vDR9533o+NbRzk=;
        b=QNK4o0spmkJdS8F9ycc0tqMHW83EBN2Z0FvDWFCvwGgX8hijTKTWtTRU9hRIxyRYmt
         bFMLRDH2C+vXg2K85KYLDvMXv5BsCdrNy3MLGvGP3bA2VmGN8wJ8tQ7zLysgEAuB9tbl
         ixHpr3rmD+f/vqWvgwJnUAc7DPD5VHqDsh8kX3Fbn0U+cUgdhO7Dt4o/LykhqvVyd5ms
         eT/ebVm2Qf0jMqgIoOaiUr6aZ5TFwiQhMQtLeC0xG4BMPxIr7KI3xkcvsMkn5lQYYw4O
         mufE6h/oLHxPsIsr0s3bkzduB/1y9EYCl7EBgatIPOBPL/NcDYq03/dOxXuncBQ2nAAK
         jTjg==
X-Gm-Message-State: AOAM532xeGTxSARvhZhlLoAiGFi08veJzrgf6zuCln8pkJOKZi1d447D
        3tgHFdSPpx9QJycqGlDebo8qKOYlugJ7EXSljBdXbhdnM0o=
X-Google-Smtp-Source: ABdhPJzQs5HWOaGr4oBKOUkG5SV+qx7C50ZekirwI6OrNE+rcVx1U6hY4cJ6QS1W+QqIhe4fn6OY1LGz4Eio1g316Pc=
X-Received: by 2002:a17:906:1947:: with SMTP id b7mr2876662eje.320.1591260926736;
 Thu, 04 Jun 2020 01:55:26 -0700 (PDT)
MIME-Version: 1.0
References: <874ks212uj.fsf@m5Zedd9JOGzJrf0>
In-Reply-To: <874ks212uj.fsf@m5Zedd9JOGzJrf0>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 4 Jun 2020 10:55:15 +0200
Message-ID: <CAJfpegux+mVxbBH7UbrGWHrQ-7Si211GwSED3h339nERgpeYJw@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: initialize error in ovl_copy_xattr
To:     Yuxuan Shui <yshuiv7@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 27, 2020 at 5:20 AM Yuxuan Shui <yshuiv7@gmail.com> wrote:
>
>
> In ovl_copy_xattr, if all the xattrs to be copied are overlayfs private
> xattrs, the copy loop will terminate without assigning anything to the
> error variable, thus returning an uninitialized value.
>
> If ovl_copy_xattr is called from ovl_clear_empty, this uninitialized
> error value is put into a pointer by ERR_PTR(), causing potential
> invalid memory accesses down the line.
>
> This commit initialize error with 0. This is the correct value because
> when there's no xattr to copy, because all xattrs are private,
> ovl_copy_xattr should succeed.
>
> This bug is discovered with the help of INIT_STACK_ALL and clang.
>
> Signed-off-by: Yuxuan Shui <yshuiv7@gmail.com>

Thanks, applied.

Miklos
