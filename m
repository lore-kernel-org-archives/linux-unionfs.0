Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A70C8C433F5
	for <linux-unionfs@archiver.kernel.org>; Thu,  6 Oct 2022 12:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiJFMVg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 6 Oct 2022 08:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJFMVf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Oct 2022 08:21:35 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3239C2C0
        for <linux-unionfs@vger.kernel.org>; Thu,  6 Oct 2022 05:21:33 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id nb11so4180104ejc.5
        for <linux-unionfs@vger.kernel.org>; Thu, 06 Oct 2022 05:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=p/a+BylFdCdO728LJbS2XQTYV3fs94fdBUxkAL78A1I=;
        b=b9QApQdACzZcMS/3ddMhFYZJ2Pp2HgYRcc64PWXyBMhKAWw5IE2ntXUx2YxQNzNY6N
         nQRf8mSnk8JpfgcX2IItlwIb0g0bpV3hgDtl9cEzHdZ0FhwtkzywBfHYQTNz2iJx0KiN
         8Z+KaB02GVBXSb4OMz+mxSlbO0TMkSmQK9Oko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=p/a+BylFdCdO728LJbS2XQTYV3fs94fdBUxkAL78A1I=;
        b=SYxqPaM1ezM1JLMoDJm3Djewy58O17dnXPhxnixEegim3Q6ENbyz4N042aT1g5R2wf
         mO4sSKdMoCetXxDi6k6FKTRuNqgtc9JPF/J2MI7rhYOws15P2b34rvK+99xQPs3Xa+Tq
         /RE94tIlZBwFit4TZhdtId93/Dgz2XFOMeVmDIWSQQCvwfc0hyR5p97gtP38DF3uqCGb
         qtoQPULiAAeXOYs0562qM7eSZNv7FysatmNZBlTKCZPmHCJ6u2spG0m+kIaZegDomSaR
         gn8czX9qQQFjATtqmIIuuHbU9OezahDkchOgQlPdqJPMsr9bfSK/gsYOp0BXguz8hB3f
         drzQ==
X-Gm-Message-State: ACrzQf09z/tYiZtB3NRLFsxEy26kwtXvLmNc1DgEOy4hRsP3prKppaC5
        bThXVtPvWUlQCWiKHl0Gb0pY2Q5m0jJakx+9xivjVw==
X-Google-Smtp-Source: AMsMyM5GJwHjtmmJbzoVrA11P8H69wHSK+Q66NpDkI1oZGPqojb8clUgWRDofTII0NiKP0MQNY9LxaNWR22+BWKa8qk=
X-Received: by 2002:a17:906:ef8c:b0:78d:4a00:7c7b with SMTP id
 ze12-20020a170906ef8c00b0078d4a007c7bmr574879ejb.187.1665058892328; Thu, 06
 Oct 2022 05:21:32 -0700 (PDT)
MIME-Version: 1.0
References: <20221004103433.966743-1-amir73il@gmail.com>
In-Reply-To: <20221004103433.966743-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 6 Oct 2022 14:21:21 +0200
Message-ID: <CAJfpeguemhcaGub8PkovtWQ-yR0y7ZRBwPRqYi99vUZWcWM5zA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Performance improvements for ovl_indexdir_cleanup()
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 4 Oct 2022 at 12:34, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Miklos,
>
> I ran into an incident of very large index dir which took considerable
> amount of time to mount the indexed overlay (~30 minutes).
> The index dir had millions of entries and I do not think that the use
> case that caused this is typical.
>
> The following two patches are based on perf top analysis of this
> incident.  I do not have access to the data set that caused the
> very long mount time, but I tested the desired CPU usage improvements
> on a smaller scale data set.
>
> It is hard to say if this extreme case of very large index dir is
> common enough to be worth any attention, so I did not tag the fixes
> for stable and I don't think it is urgent to apply them.
>
> Unfortunattely, the investigation of the incident was not timed
> optimally w.r.t. to the current merge window.
> Nevertheless, the changes are quite trivial, so you may want to consider
> them either for -rc or for next release.

Looks good.  Pushed to #overlayfs-next.

Thanks,
Miklos
