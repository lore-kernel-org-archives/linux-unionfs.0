Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93EECC433FE
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Mar 2022 14:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbiCAOuv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 09:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235396AbiCAOuu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Mar 2022 09:50:50 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4389BB83
        for <linux-unionfs@vger.kernel.org>; Tue,  1 Mar 2022 06:50:09 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id r8so5098038ioj.9
        for <linux-unionfs@vger.kernel.org>; Tue, 01 Mar 2022 06:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h12pZLLQWjKnl9av0ZtyYFXYHF4YPtyxSvcwvXIynQk=;
        b=nCnwG4NKxS0TSlYaoRcPAfcxGC1WA5p/7kTjbu6NdcCNV44q0TIFkKqsvGQPLInQ+5
         yt0uVHyaSbWRPuyRFg9+JtM7dXlajL83ANOEKismyMSTG8q0J9M2cN8YcJLa1p2cv2nu
         APWQSD9MIxYycEbqUMOXXK2XZ4pYjitnNh+x4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h12pZLLQWjKnl9av0ZtyYFXYHF4YPtyxSvcwvXIynQk=;
        b=uhXM14u13mWxpu2pnuBEXKzWEc+sNUO1ZHaGd3owQM6kOjNKu7GS6kpDlYmmuAHAZV
         u3kzZmr2bpe+JsS/OWqCrF17fmjvAocThQRBMdNwrGcGOIBAdQGTShNHEARmI3XgTSqf
         4b0sO/DDbtLQn5GJKbenOOsWcPnHOpYcNjvryfehY7i/zMUteImKWn1J9pm280f3+TxK
         9rNn+Wxy63YSnJixjHIsxsBthf6t3CIIzFPcwdrNY7R7Xy6nXneyzpiX54RSuoo23o/1
         FS2KnI2sBhUJ6ZMDJvK4JpJsQyp6Sepxg/x6I37L4iQStCxwWj3+Zzo6T7mwAlplxA8q
         mLAw==
X-Gm-Message-State: AOAM53016v05Yybz5bqmZ2631HZTtPfcCta72jyB4JfJfNfkuWE/RHcy
        H5utHSV1iG1kTMJAlYkqExa1621ArTF2JtzU0v46bA==
X-Google-Smtp-Source: ABdhPJxB87Q/GSLvjY/UA0RecLRnf0udxlwj3X9jdnWw9h5Dx6fZ97OXoBCr99MZEclnk16i8qIvsmGrmTGyhgxFqJ4=
X-Received: by 2002:a05:6638:160d:b0:314:e6e5:4699 with SMTP id
 x13-20020a056638160d00b00314e6e54699mr21276956jas.47.1646146208428; Tue, 01
 Mar 2022 06:50:08 -0800 (PST)
MIME-Version: 1.0
References: <20220226152058.288353-1-cgxu519@mykernel.net> <CAOQ4uxiWZ4TWq4LuNOHYMHDgX+2Srq_3HNe+t5z-Ch4AFw9bRA@mail.gmail.com>
In-Reply-To: <CAOQ4uxiWZ4TWq4LuNOHYMHDgX+2Srq_3HNe+t5z-Ch4AFw9bRA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 1 Mar 2022 15:49:57 +0100
Message-ID: <CAJfpegumX+H_-iDxfnCx_oAkwBYZH_5k1PhZO5F6oKz-Hrwv5Q@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: fsync parent directory in copy-up
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 26 Feb 2022 at 17:38, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sat, Feb 26, 2022 at 5:21 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
> >
> > Calling fsync for parent directory in copy-up to
> > ensure the change get synced.
>
> It is not clear to me that this change is really needed
> What if the reported problem?
>
> Besides this can impact performance in some workloads.
>
> The difference between parent copy up and file copy up is that
> failing to fsync to copied up data and linking/moving the upper file
> into place may result in corrupted data after power failure if temp
> file data is not synced.
>
> Failing the fsync the parent dir OTOH may result in revert to
> lower file data after power failure.
>
> The thing is, although POSIX gives you no such guarantee, with
> ext4/xfs fsync of the upper file itself will guarantee that parents
> will be present after power failure (see [1]).
>
> This is not true for btrfs, but there are fewer users using overlayfs
> over btrfs (at least in the container world).
>
> So while your patch is certainly "correct", for most users its effects
> will be only negative - performance penalty without fixing anything.
> So I think this change should be opt-in with Kconfig/module/mount option.

Probably should be made conditional on ovl_should_sync(ofs).

But before adding more options/complexity the performance impact
itself should be evaluated.   My guess is that it will be minimal,
since directory copy ups will generally be orders of magnitude less
frequent than file copy ups.

Thanks,
Miklos
