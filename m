Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988ACC28D13
	for <linux-unionfs@archiver.kernel.org>; Mon, 22 Aug 2022 15:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbiHVP1I (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 11:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236609AbiHVP0m (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Aug 2022 11:26:42 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C3233C
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Aug 2022 08:24:36 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id j21so16528371ejs.0
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Aug 2022 08:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=+T86Wl72f+FeWeRtOGkVlmWRkAxRXlHA5m5R3vqpGWs=;
        b=Ol0z0PkAjZXBna32Isqt8G4NNZVcvypCiD7npmdqQUrUng9iYrmXQC6mZ9uyeKe+HU
         cL69L/rzWsjJlHO2ALmaAx1ltJf+3dbncIBnOawpF4XoHXnqoZeovsw5Xc+gbrZTFEjY
         dCjgW6BBlBQ0ZCL3PY9LQlTsHnuxHWVSPkhNw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=+T86Wl72f+FeWeRtOGkVlmWRkAxRXlHA5m5R3vqpGWs=;
        b=wLr8i+mxBByct0puZntpFnHt2Y+wAG1kF9F7otU9sK0DLfks0R1DDhxZT84S1UcWft
         HpgC5uiY1ZL/uH2W+3/zjQOIoZEjWZRXk52dKfFB0hom6Iw/pyFNNZWljyNOomCnatkH
         Kc7XUQLuyupKvU1fDDILyML0x9WyTpVJiBE7e+MKSi+wPcTzOCj+8rmtJJmPSbN3afFQ
         M5H8bTzmQDuktg5yFn/j+V3PtJ0T/+W+HS2/OjzohR1KWw8tUsuPyMv+W763mpW9Fmz/
         ZePlzDyXRxdbp46NZyNuSdzmrLyUbytXtU5c4s7NAkUYsj0EDMeg0kLNLSzoAejIVuiw
         fU7Q==
X-Gm-Message-State: ACgBeo2kBXUOoVtg/Gh4ZEfzvtjckGXj4bCsgBEoWBqVRTA9ZtvjZJ2v
        O10TH3EPKx5XRhL+VWu6Om/AIEJwBdAK+RHFvlLrJg==
X-Google-Smtp-Source: AA6agR5j8M3rqBkCxM8dnHG6ED3RCNQdniNKcKwM4yLtbj+oQVl6x+Revnno5eoSlvEEgoKpvmg1Nap22zvMyWaen9w=
X-Received: by 2002:a17:906:8a4a:b0:73d:8471:e34b with SMTP id
 gx10-20020a1709068a4a00b0073d8471e34bmr2856240ejc.523.1661181874865; Mon, 22
 Aug 2022 08:24:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220822115257.7457-1-goriainov@ispras.ru>
In-Reply-To: <20220822115257.7457-1-goriainov@ispras.ru>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 22 Aug 2022 17:24:24 +0200
Message-ID: <CAJfpeguyD-znkZVwmiYZCK6tMsoJc+UzMKnkWxb7TToT1DFb4Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: Fix potential memory leak
To:     Stanislav Goriainov <goriainov@ispras.ru>
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 22 Aug 2022 at 13:53, Stanislav Goriainov <goriainov@ispras.ru> wrote:
>
> ovl: Fix potential memory leak in ovl_lookup()
>
> If memory for uperredirect was allocated with kstrdup()
> in upperdir != NULL and d.redirect != NULL path,
> it may be lost when upperredirect is reassigned later.

Can't happen because the first assignment of upperredirect will only
happen if upperdentry is non-NULL, while second one will only happen
if upperdentry is NULL.   I understand why static checker fails to see
this: it doesn't know that dentry->d_name will never contain '/'.  In
this case the looped call to ovl_lookup_single() can be ignored and it
is trivial to prove that d.redirect can only be set if *ret is
non-NULL.

Thanks,
Miklos
