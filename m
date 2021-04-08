Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 222D6C433ED
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 11:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B486102A
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 11:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhDHLaU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 8 Apr 2021 07:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhDHLaT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Apr 2021 07:30:19 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B674C061760
        for <linux-unionfs@vger.kernel.org>; Thu,  8 Apr 2021 04:30:07 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id g4so929971vsq.8
        for <linux-unionfs@vger.kernel.org>; Thu, 08 Apr 2021 04:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ak9Ae0yTiCNTU5hM52FKHP/8oyThhjCQqIFAS1ZbKxk=;
        b=B64qG+/5Muun4VUMM5H5hUDxppWptTHN3p37zNCDFRk3+dg8viDUVP/tqj+nAo4jsw
         h5S49xxkmKptZ4jNywUGAEWEJEErcPCdDszmIoIcmd6fdEfuQ8oOzn3yE4Sl5bspMthZ
         Xw6YtoOvwdRdQn4M5vr28PNw7cG5SVMy7vYYk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ak9Ae0yTiCNTU5hM52FKHP/8oyThhjCQqIFAS1ZbKxk=;
        b=FxBHdq7f6/PdpqypNa+qR8OQosXtnRm8ugZpyvrx6Tz6yHJ2Tq6Tk+5ybSQG4IVoAD
         Q6Rcoo5gdbxws/aTjA8rElUqFmwNz/81qfoCSk+wmOSqGC9zcnIo5w5z9Pp85YMqia+F
         ujmxO6YF3iEO4IfaxCdflZzLiczs8EkYv+o5xjRSq3uUlbYfXFCOCp14fhLIVBoyw+MO
         XHYEfY4axUNWC5AIP25ombZCeVogpib25a5gWVRhkU1CHZZ+qmcI5hF+ySYlfv0cJGCT
         hOg+gAR3c1z2t8p7p46+sL4tTdbgBgkXUzzNmRleMjJ86QwX1FkO1h47wlaj2MIHIDLT
         +lqQ==
X-Gm-Message-State: AOAM5335otrJQqmsFQ61zWwfE9+1l7QKiJL3IMQapJYOVdIbn/cdgmNI
        x1txHwoM1KAn9XQxsq10ok8qMyE5u6/0kQPG7OdQlFBoEtq2Ww==
X-Google-Smtp-Source: ABdhPJzTGm60kzUY9mUsk4v0hCcmJaIlELIxYx6dKS538hcn93MRQdcaNdTlPD/expOHAEkomVkIgRHzfeJbzl4buI0=
X-Received: by 2002:a67:6a85:: with SMTP id f127mr5215450vsc.9.1617881406723;
 Thu, 08 Apr 2021 04:30:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210408112042.2586996-1-cgxu519@mykernel.net> <178b13dbf0a.c5d5924718458.7870418673694557579@mykernel.net>
In-Reply-To: <178b13dbf0a.c5d5924718458.7870418673694557579@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 8 Apr 2021 13:29:55 +0200
Message-ID: <CAJfpegt5vVAtik=SXL26G0Tjh8yzZ6DvD6wLtfbXTinqpkxVeg@mail.gmail.com>
Subject: Re: [PATCH] ovl: check VM_DENYWRITE mappings in copy-up
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     linux-unionfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 8, 2021 at 1:28 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 19:20:42 Chenggua=
ng Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
>  > In overlayfs copy-up, if open flag has O_TRUNC then upper
>  > file will truncate to zero size, in this case we should check
>  > VM_DENYWRITE mappings to keep compatibility with other filesystems.

Can you provide a test case for the bug that this is fixing?

Thanks,
Miklos
