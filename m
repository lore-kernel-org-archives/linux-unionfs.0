Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB76C433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 10 Mar 2022 09:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241076AbiCJJz1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 04:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241160AbiCJJzT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 Mar 2022 04:55:19 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCE6B0EBF
        for <linux-unionfs@vger.kernel.org>; Thu, 10 Mar 2022 01:54:05 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id c23so5813468ioi.4
        for <linux-unionfs@vger.kernel.org>; Thu, 10 Mar 2022 01:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sRGZ8yfimooUMwFcIyclB2IPhoLT4oZ8qQQY9dWOKC0=;
        b=g/9pNC+ca/Ysa6Uh2iUq//P+bkmtRaEp4zUYjz5W1HAhRxnnDz0wb6miQlUGhchonY
         GsEzMN283IM07WvntYSHO/uwNg0Db1ZKE3KecBPXI7mM+20yJBkq3RCmai9ZOSy4Anft
         TUpU4fvioo2eM3tpyIXIq9IiHHdeov78ke0kI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sRGZ8yfimooUMwFcIyclB2IPhoLT4oZ8qQQY9dWOKC0=;
        b=gU3Q9yZE/QnJ5X1OjwHZ8YekiH+C2ffDganpi3VfU5+I0UIGkjZZDzFc/34RSfytDv
         zmKL7T2oc+EeG1pXcuBrYOlaHC72dzUn1uruSQJllxcZjlJbukJzdd59G8Xk+dydle0r
         ya/juiyRGld3YlkP1uYHFB2be3EofVaRKeFTEgAgNw94JuCBR58dmUl1dEoPJf5nt/MQ
         JRk3TqrQAqFrDkyCCT4Ijl4VrVuMkhKtSUdfb/mym2fXFaAN3NOkav2WqJqG+WsYzTaG
         nuE7ROJ0TTkWOtLWp/s+cHbtLjPlJPXPYwK7jre9T6l1tOn7vggqTooGugcTcMGvyH4m
         MTKQ==
X-Gm-Message-State: AOAM5310ZL4RBNMWqRbAuMTkKOXyocZcAFnuuSni2BHpc5yAU+0hsRd1
        skhLfH5zk1JzePD1QlL57xd2kvy1IbMSoZv3DZU6+Q==
X-Google-Smtp-Source: ABdhPJyJKXqwGH8V3alpV+kqBUX4mjI+J4uCqj4HwiTapTL7HoBTTqGz53MdYAxzdc6moDJ0r/Unal7OVZy4Dc7Pxeo=
X-Received: by 2002:a05:6638:3049:b0:317:9a63:ec26 with SMTP id
 u9-20020a056638304900b003179a63ec26mr3281496jak.273.1646906043785; Thu, 10
 Mar 2022 01:54:03 -0800 (PST)
MIME-Version: 1.0
References: <20220305160424.1040102-1-amir73il@gmail.com> <20220305160424.1040102-7-amir73il@gmail.com>
In-Reply-To: <20220305160424.1040102-7-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 10 Mar 2022 10:53:52 +0100
Message-ID: <CAJfpegveDAJMPste+514imoi74MHcgQ_A+BbQEyXmrmAMnEz-A@mail.gmail.com>
Subject: Re: [PATCH v4 6/9] fs: report per-sb io stats
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "Ted Ts'o" <tytso@google.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 5 Mar 2022 at 17:04, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Show optional collected per-sb io stats in /proc/<pid>/mountstats
> for filesystems that do not implement their own show_stats() method
> and have generic per-sb stats enabled.

I still think it's wrong to extend the /proc/*/mount* family of
interfaces.  The big issue is that the kernel has to generate this
info for *all* mounts, even though the user may be just looking for
information on a specific mount.  Your workaround is to enable the
info generation for only a subset of fs types, but this doesn't solve
the fundamental issue.

So let's please implement a per-mount interface.  Yes, it's a much
bigger project, but one which needs to be done at one point, and which
would be generally useful.   There was tons of discussion around this
when dhowells tried to create one, and there was a suggestion by Linus
which I think all parties found acceptable:

 - return basic info in a binary format (similar to e.g. statx)
 - after the fix binary structure allow misc info to be added using an
ascii format

And since generating the info may be expensive in some cases, the
interface would need to allow selective queries (which statx does for
binary fields, but for ascii ones this is a new challenge).

I think allowing the user to query the list of supported fields should
also be possible (again, statx supports this).

So there are a number of requirements for this interface, and I'm not
quite sure what the best solution is.   I can try to put something
together if there are no objections...

Thanks,
Miklos
