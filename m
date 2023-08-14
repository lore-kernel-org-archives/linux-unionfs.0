Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB8FC001DB
	for <linux-unionfs@archiver.kernel.org>; Mon, 14 Aug 2023 11:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbjHNLie (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 14 Aug 2023 07:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjHNLiL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 14 Aug 2023 07:38:11 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7B994
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Aug 2023 04:38:11 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id a1e0cc1a2514c-79ddb7fae73so72455241.3
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Aug 2023 04:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692013090; x=1692617890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CfSGXdjq/EthvVoPMHKzpIAp+w3cf/VYazg6WrhmxpA=;
        b=Xsd+DuWB7ciEe05IJ8NqGo62B2Iy0whqqjkrBY1HmriZcEwT+OajdR8Pf6lri95B9k
         ZNMuIIFCznxkMpo/eB8h4HPs2AWI0x3JHjKfezaVMOs2aRjXCQkQs3R2UzWvu0UsSrbp
         XDlHfAgX+VitmNsQUf4LlTKWaVUrmU4+QjKT+3BgvtrAxZ2a1DbhFbCr0pv7PsS0gaeY
         /IV3TEupz+WewxZN+NcaMjkYaGYGrIgqkkdjPLc9w2Ol6sH7LszCB+5cjDD1umNwWNFk
         cb1s2/BQDwfLBeWDKq3oZL5aKunyPdBV8kzJPNxbZRs2JMEMB0eFVrIFAk+LgbHvZ963
         WP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692013090; x=1692617890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CfSGXdjq/EthvVoPMHKzpIAp+w3cf/VYazg6WrhmxpA=;
        b=L9ej/orIH82wD+VlVvDb/HFcU2u+mRemfXa5DIepJKcSmCfNhaBtIe9vwVgzmJVLWw
         8LsvinNfE5LhmZlogaGf4VLSpYpnqDyBSlLwRatLAxQT4Hwgwy9QjiGVCSOyDEljJGWx
         LT9H0S0AvgBPg4ehTce3XwXmlHF7XJ0V896iBZ9ZOgOHIYbMFU1xc1CPYraa/Jwt4O5z
         IJygExqvmGp+MIP/ROr4qtfocTIvUm1tZiTrC1bxY7Wa5VjFEdfz+Wt/T2WpLqQdl46i
         LArwOGMwDyM1gFKUoJqimRdEE1Sct0b7bMgR15Dfy6NZcmsuaEREtrCdWnhmKXxOwSTu
         ZmwQ==
X-Gm-Message-State: AOJu0YwfuABN2bnY5oS7m4jSt8CzqTNDF31XH7gcb+Mvzjvk5J0ymtuN
        ZhdYt+6OPoJtbIXK4bLzFMcUS8RIbwGCVvOSPTlf/Fwt
X-Google-Smtp-Source: AGHT+IFmKvMvKVhQDoWipsyuQleQN5N1RfOx5NrrmVQBMqs2ZZnqq7flQ9tuDxOBKKkaU8mkKIQHLFUuGloJWI5xVIE=
X-Received: by 2002:a67:ad1a:0:b0:443:6352:464c with SMTP id
 t26-20020a67ad1a000000b004436352464cmr6055928vsl.15.1692013089963; Mon, 14
 Aug 2023 04:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230720153731.420290-1-amir73il@gmail.com> <CAJfpegtbBy63yCej3A6m3NvdroAJyi3WMz9L=xt5piaSyV=AKw@mail.gmail.com>
In-Reply-To: <CAJfpegtbBy63yCej3A6m3NvdroAJyi3WMz9L=xt5piaSyV=AKw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 14 Aug 2023 14:37:59 +0300
Message-ID: <CAOQ4uxhUQ8wCb3T3P_P5Ere1Hd+EaZ7ub2V_ErYU0rdrr=QRbw@mail.gmail.com>
Subject: Re: [PATCH 0/2] overlayfs lock ordering changes
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Aug 11, 2023 at 4:06=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Thu, 20 Jul 2023 at 17:37, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Hi Miklos,
> >
> > These prep patches are needed for my start-write-safe series [1].
> > This is not urgent and the prep patches don't need to be merged
> > for next cycle, but I think these are good changes regardless,
> > so wanted to post them for early review - if you like them you can
> > queue them for 6.6.
> >
> > It is quite hard to do the review of the locking reorder patch from the
> > diff itself and I couldn't figure out a better way to split this change=
.
> > I've intentionally left some otherwise useless out: goto labels to
> > make the patch review a bit simper - they could be removed later.
> >
> > On the good side, lockdep was very tough with me and it easily detected
> > bugs in the earlier versions of the patches.
> >
> > Going on vacation. will be back round rc6.
> >
> > Thanks,
> > Amir.
> >
> > [1] https://github.com/amir73il/linux/commits/start-write-safe
> >
> > Amir Goldstein (2):
> >   ovl: reorder ovl_want_write() after ovl_inode_lock()
>
> This one generally looks good.  The failure paths will need careful
> review, because those are usually not exercised by the test suites.
>
> >   ovl: avoid lockdep warning with open and llseek of lower file
>
> But I dislike this one.  Seems like a bad workaround for a possibly
> non-issue.  I understand the desire to silence lockdep, but surely we
> can do better.

Well, I didn't do it to silence lockdep. I did it as a prereq for
start-write-safe fsnotify hooks (see [1] above).
Silencing lockdep is an added bonus that I observed along the way.

v2 [2] has a less hacky, but more noisy version of this patch which
minimizes the scope of ovl_want_write() to when we need it.
Let me know if this is what you had in mind.

After looking more closely, I found another possible deadlock with
nested overlay, which I think is real and added another commit to fix it.

[2] https://github.com/amir73il/linux/commits/ovl_want_write-v2

Thanks,
Amir.
