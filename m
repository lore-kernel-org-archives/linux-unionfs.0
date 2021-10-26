Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBFD8C433F5
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Oct 2021 09:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C34FF60E08
	for <linux-unionfs@archiver.kernel.org>; Tue, 26 Oct 2021 09:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbhJZJhT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 Oct 2021 05:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbhJZJhS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 26 Oct 2021 05:37:18 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F9DC061745
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Oct 2021 02:34:55 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id h20so9364412ila.4
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Oct 2021 02:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EMo3G+rnq75NpQbwH0+NbM0o7nszSNXG0JjaBACvQVs=;
        b=KYlZLGxl1O7r3/xh1OV2RIoEuge2dtv4aRia1tBPMPjMZkhdxgGBSZ6ixBAuloCSgD
         oDU9jWj9YxWPWC3YWWzWgbh//mXhSBDclfHoJ4Xu7HMy0rBx10oFDdt6A0E4v9tAn74V
         /C+9uJHI1jCEAr4WoGfx6r2zOQTaMTC0c8P+yf56wyLt/vrOYzem+vd5+ow3QgSookR7
         vJooTn6kISuNaH9bTMspha5UIZajI4Zv8qzqjxInayN2VDfnz9JWf6vPTKAiRfDje/Hx
         ODY1BzQvcZkbi9dhZP7X++UNhyS4KXGRyiy0j3UNMz4r8+YfIEkVQkKX6/pQQZbGFp60
         7IjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EMo3G+rnq75NpQbwH0+NbM0o7nszSNXG0JjaBACvQVs=;
        b=OIanIWZetaMwWR4+y8gMFZSmdOiRr0fRlPpsKFtcXqr9KGsNeWiQjwrSBdDu0KRSas
         cQIb+uWIXhZedMuEixqy+Id2UFb9Y4WYEETWzHaJGyfDcQhzI0eTIdrymUax6l6IlLmk
         lUzQ9kAlzWiDs9cRK5Mj6tsVuNxwRJYns3Rnngp8foZRCt8fWqSumWYT2ieLcphQVehl
         q2zosN3UGAM3ka3tb3rZa1FnVpRFff+9qImrQjOO5QaSqxuKHCvqkkiFKwMuQNOenBjc
         mewGjsAVJzFdERBUyrGiEzJ18B/2TQXUAmmhdoZ6A8ova2IeZZxCMs0ytsArwXbOwEPI
         t/Uw==
X-Gm-Message-State: AOAM532hje2n9LYviujhKi2GaF8qDjuJqwbUPm0iH9xAVDukOqozGx+y
        r3v9k5W8hWNI29eEoiFxm8lTYR2vtbpaQrosVG/NcCkp
X-Google-Smtp-Source: ABdhPJxChvsGl7UfyKbebI4qZ34q0PfZ/sbpvynIs4pDp0Y8fGW4ZiDFeWht4n3wl5St01HbEFP4jL14tzWXfuzWf8c=
X-Received: by 2002:a05:6e02:18cf:: with SMTP id s15mr8922097ilu.198.1635240894454;
 Tue, 26 Oct 2021 02:34:54 -0700 (PDT)
MIME-Version: 1.0
References: <CADmzSSj6TCP9xE9q-oOjE_MzfDg_WgtOXCXzW1Z5-ZxPZo4jBQ@mail.gmail.com>
In-Reply-To: <CADmzSSj6TCP9xE9q-oOjE_MzfDg_WgtOXCXzW1Z5-ZxPZo4jBQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 26 Oct 2021 12:34:43 +0300
Message-ID: <CAOQ4uxhRjeg7L7SLBHGo6pnJO+8ww_cvS1E2MvRsRDM29+HFGA@mail.gmail.com>
Subject: Re: nfs as lower
To:     Carl Karsten <carl@nextdayvideo.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Oct 26, 2021 at 10:17 AM Carl Karsten <carl@nextdayvideo.com> wrote:
>
> I am trying to replicate the setup described below,
> (from: https://www.spinics.net/lists/linux-unionfs/msg07098.html )
> which implies a successful mount, but all of my attempts error with:
>
> mount: /e/merged: wrong fs type, bad option, bad superblock on
> overlay, missing codepage or helper program, or other error.
> [ 3640.328337] overlayfs: upper fs does not support tmpfile.
> [ 3640.333245] overlayfs: upper fs does not support RENAME_WHITEOUT.
> [ 3640.333266] overlayfs: upper fs does not support xattr, falling
> back to index=off and metacopy=off.
> [ 3640.333281] overlayfs: upper fs missing required features.
>

These kernel logs are the only relevant information.
Do you get the same kernel logs for all the overlayfs mount attempts?

As overlayfs is trying to say, the problem is clearly with upper fs
and there is no information about what upper fs is.

The setup that you are trying to replicate was using tmpfs as upper,
which should work fine.

Thanks,
Amir.
