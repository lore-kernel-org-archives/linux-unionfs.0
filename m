Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C53C76188
	for <linux-unionfs@archiver.kernel.org>; Mon,  3 Apr 2023 19:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjDCTAk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 3 Apr 2023 15:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDCTAj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 3 Apr 2023 15:00:39 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A762D5E
        for <linux-unionfs@vger.kernel.org>; Mon,  3 Apr 2023 12:00:38 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id g17so26280521vst.10
        for <linux-unionfs@vger.kernel.org>; Mon, 03 Apr 2023 12:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680548437;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DlZX1z4OKts3iToZtTa/9fHXMCtnBGuF6Q26f4b1OVw=;
        b=jKNIeXmeH9uH/AM49iBjIHRyFAHKY9nNQfiF7NW84mzixL3ULFCkHi3yoT9PCG/Hdg
         JBkbJNSWxXa5Emvh0jQ1w4nV54tFkBDibIya8kH36yMzTR2+4HYcYXVxoHUduVELIQRh
         WVfbqYWZcB1lMU7IbpOqATxr2VqTGfVaF29kXdjc2lumrm6vhAo76sYzNU7sw8KJfq1X
         t7i1k+4+whT70E8ubXjuCFoFD5XXV8uaszzUOtIGI7uItB3XsQW8fB18x4PHDk/ndo2t
         +jxIIg/+/pBmnE9mBPfyrSMN6yTYvZWXOIm9KPQguniGFTrO1DA7SA61TXrASTM34ezT
         OySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680548437;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DlZX1z4OKts3iToZtTa/9fHXMCtnBGuF6Q26f4b1OVw=;
        b=LyEh1KNGzmQUOWnjqoSgu4Yc8xAE0ipW/KRnPdPFMmLq82GqTU5luDgmHmtRMk1R3/
         hgWakWPIIKbTFVCpNv8SvEefSc9OKRPU17nQb82ACrr528OdNAWEOCsA1xmGU7RL7ZQD
         CF5oVYPiJwUuUki4mDb5J3evkFQ/ecF7vEH8PQsl/g9hSAO/OlR/ZCscoJEdgxkUsMHI
         CAABlAXfVgpN2uCUYu3m0bxMyQSVeE8vGfC/miBfcmn3YR7gggv2PEPVL79FZ8ItDKqB
         7HgYCdNhnHdtV/hLyoSs8TtVdw9W+iuObXdkA7sqNSbgPsJveBnoguzfh+ZabfeTIfid
         dxEA==
X-Gm-Message-State: AAQBX9e1dvR9vjW5p/O38K2zui1U5ao6wQWen/JupajWctZqXhe/uzAv
        gJVa5TT+SrQgo0QUWIyq6YONIvd1e/Q2+guQblc=
X-Google-Smtp-Source: AKy350ZZFyBKOtHdwLPa8mtoRWgm64iSdfDqlqXVCdf4eQBeKkJ24YUvz6Si3+IhK2c4YvfOA/UVcfKcpLbGfCmfcJ0=
X-Received: by 2002:a67:d286:0:b0:426:7730:1b8a with SMTP id
 z6-20020a67d286000000b0042677301b8amr375827vsi.0.1680548437505; Mon, 03 Apr
 2023 12:00:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1674227308.git.alexl@redhat.com> <5fb32a1297821040edd8c19ce796fc0540101653.camel@redhat.com>
 <CAOQ4uxhGX9NVxwsiBMP0q21ZRot6-UA0nGPp1wGNjgmKBjjBBA@mail.gmail.com>
 <b8601c976d6e5d3eccf6ef489da9768ad72f9571.camel@redhat.com>
 <e840d413-c1a7-d047-1a63-468b42571846@linux.alibaba.com> <2ef122849d6f35712b56ffbcc95805672980e185.camel@redhat.com>
 <8ffa28f5-77f6-6bde-5645-5fb799019bca@linux.alibaba.com> <51d9d1b3-2b2a-9b58-2f7f-f3a56c9e04ac@linux.alibaba.com>
 <071074ad149b189661681aada453995741f75039.camel@redhat.com>
 <0d2ef9d6-3b0e-364d-ec2f-c61b19d638e2@linux.alibaba.com> <de57aefc-30e8-470d-bf61-a1cca6514988@linux.alibaba.com>
 <CAOQ4uxgS+-MxydqgO8+NQfOs9N881bHNbov28uJYX9XpthPPiw@mail.gmail.com>
 <9c8e76a3-a60a-90a2-f726-46db39bc6558@linux.alibaba.com> <02edb5d6-a232-eed6-0338-26f9a63cfdb6@linux.alibaba.com>
 <3d4b17795413a696b373553147935bf1560bb8c0.camel@redhat.com>
 <CAOQ4uxjNmM81mgKOBJeScnmeR9+jG_aWvDWxAx7w_dGh0XHg3Q@mail.gmail.com>
 <5fbca304-369d-aeb8-bc60-fdb333ca7a44@linux.alibaba.com> <CAOQ4uximQZ_DL1atbrCg0bQ8GN8JfrEartxDSP+GB_hFvYQOhg@mail.gmail.com>
 <CAJfpegtRacAoWdhVxCE8gpLVmQege4yz8u11mvXCs2weBBQ4jg@mail.gmail.com>
 <CAOQ4uxiW0=DJpRAu90pJic0qu=pS6f2Eo7v-Uw3pmd0zsvFuuw@mail.gmail.com>
 <CAJfpeguczp-qOWJgsnKqx6CjCJLV49j1BOWs0Yxv93VUsTZ9AQ@mail.gmail.com> <CAOQ4uxg=1zSyTBZ-0_q=5PVuqs=4yQiMQJr1tNk7Kytxv=vuvA@mail.gmail.com>
In-Reply-To: <CAOQ4uxg=1zSyTBZ-0_q=5PVuqs=4yQiMQJr1tNk7Kytxv=vuvA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 3 Apr 2023 22:00:26 +0300
Message-ID: <CAOQ4uxich227fP7bGSCNqx-JX5h36O-MLwqPoy0r33tuH=z2cA@mail.gmail.com>
Subject: Lazy lowerdata lookup and data-only layers (Was: Re: Composefs:)
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > >
> > > I think lazyfollow could be enabled by default after we hashed out
> > > all the bugs and corner cases and most importantly remove the
> > > POC limitation of lower-only overlay.
> > >
[...]
> > >
> >
> > Lazy follow seems to make sense.  Why does it need to be optional?
>
> It doesn't.
>
> > Does it have any advantage to *not* do lazy follow?
> >
>
> Not that I can think of.

Miklos,

I completed writing the lazy lookup patches [1].

It wasn't trivial and the first versions had many traps that took time to
trip on, so I've made some design choices to make it safer and easier to
land an initial improvement that will cater the composefs use case.

The main design choice has to do with making lazy lowerdata lookup
completely opt-in by defining a new type of data-only layers, such as
the content addressable lower layer of composefs.
The request for the data-only layers came from Alexander.

The current patches only do lazy lookup in data-only layers and the lookup
in data-only layers is always lazy.

Data-only layers have some other advantages, for example, multiple
data-only uuid-less layers are allowed.
Please see the text below taken from the patches.

What do you think about this direction?

Alexander has started to test these patches.
If he finds no issues and if you have no objections to the concept,
then I will post the patches for wider review.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-lazy-lowerdata-rc2

Data-only lower layers
----------------------

With "metacopy" feature enabled, an overlayfs regular file may be a
composition of information from up to three different layers:

 1) metadata from a file in the upper layer

 2) st_ino and st_dev object identifier from a file in a lower layer

 3) data from a file in another lower layer (further below)

The "lower data" file can be on any lower layer, except from the top most
lower layer.

Below the top most lower layer, any number of lower most layers may be
defined as "data-only" lower layers, using the double collon ("::") separator.

For example:

  mount -t overlay overlay -olowerdir=/lower1::/lower2:/lower3 /merged

The paths of files in the "data-only" lower layers are not visible in the
merged overlayfs directories and the metadata and st_ino/st_dev of files
in the "data-only" lower layers are not visible in overlayfs inodes.

Only the data of the files in the "data-only" lower layers may be visible
when a "metacopy" file in one of the lower layers above it, has a "redirect"
to the absolute path of the "lower data" file in the "data-only" lower layer.
