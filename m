Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CADC001DB
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Aug 2023 13:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbjHKNHS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 11 Aug 2023 09:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236490AbjHKNG7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 11 Aug 2023 09:06:59 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E3C30F2
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Aug 2023 06:06:28 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-986d8332f50so278166066b.0
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Aug 2023 06:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1691759181; x=1692363981;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6q6qo6kmuChOWkghTOsLtD+BINZ5s5wvE429qhYvtHA=;
        b=JQIPEb9dsNAGZEzHK7NSsPCCGCtIJxciK2rVlAm6VR3uCygtRxgQLuDXjKLkTFQHlS
         vsBAqTbU4/BLcpGnVpXYWtUHTCluQugMwExkzvSsxxHFOX54Y8v/Oi1xrtXfc3mp1Yei
         x6PYkeoTILABVxnzVqzs9kROLutp42Yd0LKw8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691759181; x=1692363981;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6q6qo6kmuChOWkghTOsLtD+BINZ5s5wvE429qhYvtHA=;
        b=UkpwGtSAtQShJNFb9bfDKTblG6gRXlSYsyWP+4aW20VFPmu2X5WvqJOcA41ss+/Z3A
         g+WCrnwRiSEjDBNE40bGdmYrPNesb4S6xznibQ5i4BkI1xKA9Y6iysIT8Syidum1ItNe
         k99sH7Ac1P0G+OZljlm6phx4DO84HazbzJGo9Yp7WtbQnmLWpFR0hVgjy2Vo7dwwUs7U
         PCxwHdmbY7SZZRx1Gha2XvumqTsDnr29lfbBhbGWRfsGaEt9UveZ0ndJGenD6W/KVKqT
         p/lMkGBhfEA7+FdrXx4KMt0QX+F9HhWG0OoAn3GHRyTdw1ve2UYMuUMWQ1L4+gMg3s1d
         1SjA==
X-Gm-Message-State: AOJu0YzZeioIHmwvJD9eRankFGZ6Y6jqZGzR33xbqxhualWxZYWQHkgf
        0l41EogTZTi5wgHWC2yQeAXECiqy3Xra6gjJ1PhioQ==
X-Google-Smtp-Source: AGHT+IHIPePHLsR4kaS+Utl5GcP71kWyXQJE6icRW0sh5ji3op3nqR9QTRIJt+p4uNkzvxHe9MX0iFZpzoFCvuH5jRE=
X-Received: by 2002:a17:906:3115:b0:99c:5707:f458 with SMTP id
 21-20020a170906311500b0099c5707f458mr1487562ejx.72.1691759181420; Fri, 11 Aug
 2023 06:06:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230720153731.420290-1-amir73il@gmail.com>
In-Reply-To: <20230720153731.420290-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 11 Aug 2023 15:06:09 +0200
Message-ID: <CAJfpegtbBy63yCej3A6m3NvdroAJyi3WMz9L=xt5piaSyV=AKw@mail.gmail.com>
Subject: Re: [PATCH 0/2] overlayfs lock ordering changes
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 20 Jul 2023 at 17:37, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Hi Miklos,
>
> These prep patches are needed for my start-write-safe series [1].
> This is not urgent and the prep patches don't need to be merged
> for next cycle, but I think these are good changes regardless,
> so wanted to post them for early review - if you like them you can
> queue them for 6.6.
>
> It is quite hard to do the review of the locking reorder patch from the
> diff itself and I couldn't figure out a better way to split this change.
> I've intentionally left some otherwise useless out: goto labels to
> make the patch review a bit simper - they could be removed later.
>
> On the good side, lockdep was very tough with me and it easily detected
> bugs in the earlier versions of the patches.
>
> Going on vacation. will be back round rc6.
>
> Thanks,
> Amir.
>
> [1] https://github.com/amir73il/linux/commits/start-write-safe
>
> Amir Goldstein (2):
>   ovl: reorder ovl_want_write() after ovl_inode_lock()

This one generally looks good.  The failure paths will need careful
review, because those are usually not exercised by the test suites.

>   ovl: avoid lockdep warning with open and llseek of lower file

But I dislike this one.  Seems like a bad workaround for a possibly
non-issue.  I understand the desire to silence lockdep, but surely we
can do better.

Thanks,
Miklos
