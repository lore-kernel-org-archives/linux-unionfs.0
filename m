Return-Path: <SRS0=+UIx=6F=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125BEC2BA19
	for <linux-unionfs@archiver.kernel.org>; Tue, 21 Apr 2020 09:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AB4A20857
	for <linux-unionfs@archiver.kernel.org>; Tue, 21 Apr 2020 09:25:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Ap5+GIXn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgDUJZO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 05:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726120AbgDUJZN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Apr 2020 05:25:13 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8818BC061A0F
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Apr 2020 02:25:13 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id x1so10439825ejd.8
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Apr 2020 02:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1BjAvO7R32fc/sZSMNhFfZ2p0Wiu2RIuvl+mLMZkI5w=;
        b=Ap5+GIXnr34NgGvvS23uo64UJD+Dgli2QKItnq7VXjnTmcIkn107RzMsmYcio9H+wv
         rMmhcHs4gx9NnJr+1rEJYdYqYTOaP4de8TQS82JIDVuXDl3arQLyHRHxQ9rg1IP/+9Bx
         Hkeo5Ob6ocMYsDkjLxDOWyFOafOrl24ZWlevk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1BjAvO7R32fc/sZSMNhFfZ2p0Wiu2RIuvl+mLMZkI5w=;
        b=cYHDqsy9w14rt+loLjDSSv6NqCq1JM/JEgOYiJpa8UxzdD84Cvvdp0TjNGLVs6gJXZ
         PWAucFiHNlHBZz4KPEi2QTRjKiSukqCeu55AiWDRpRKY7J+NDnxV9HeJ4XLTb9QDz6k9
         g13twr8hk4/fZnew0SQR4qY+CTqav4FZ23TlSjFcca9zvSmjE/op2YiaaI2WL10PicY9
         Ugh5i1olIxmK9zt08vhGkphby23iEL+NcC/oyVnmmdjSR0O1nHT7cl7PUF0PesWkzja0
         zUeg/Rz6V+rH44KLO/7BOzPbYzQHINRENBOum7D2g5J6etCmj37OabKMhDmLNs9tC3ew
         /3Og==
X-Gm-Message-State: AGi0PubkBpF9tTs3IEt5uwG33gYfP5SjgNDqwq3pQ1DCKtYrp+zKSNXW
        Um7mqbWu7NEzLAsgzAebGOBjgEjKb4nR/VAHRHjgBVVP
X-Google-Smtp-Source: APiQypJzvMH5v3oKS8U+8g0X3bIBKm5BjEcpL35gOnm38nKHWOu+oTjQHW2gN7gDkL7GVz62s3/h6okUW9XTGPpFzho=
X-Received: by 2002:a17:906:8549:: with SMTP id h9mr19543059ejy.145.1587461112190;
 Tue, 21 Apr 2020 02:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200410082539.23627-1-amir73il@gmail.com> <20200410082539.23627-2-amir73il@gmail.com>
 <CAJfpegtGDcsBWdXXXgiP2UxU2iz02YSO1vOCkaBq_SvJbFJhFw@mail.gmail.com> <CAOQ4uxjR10X5FADiHyCPZEBbS-wYp=Nj8Xqm-hyMiuCNMfmt1A@mail.gmail.com>
In-Reply-To: <CAOQ4uxjR10X5FADiHyCPZEBbS-wYp=Nj8Xqm-hyMiuCNMfmt1A@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 21 Apr 2020 11:25:01 +0200
Message-ID: <CAJfpegvgeMbwyf1EAtHQqMsgykqmGqKR5NLG-qX0nf_+H0xBQw@mail.gmail.com>
Subject: Re: [PATCH 1/3] ovl: cleanup non-empty directories in ovl_indexdir_cleanup()
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 17, 2020 at 6:56 PM Amir Goldstein <amir73il@gmail.com> wrote:

> Ok. fixed tested and pushed to ovl-workdir.

Thanks.   Pushed to #overlayfs-next.

Thanks,
Miklos
