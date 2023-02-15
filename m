Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE71C636D7
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Feb 2023 15:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjBOPcr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Feb 2023 10:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjBOPcp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Feb 2023 10:32:45 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25883669B
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Feb 2023 07:32:41 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id a10so22641831edu.9
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Feb 2023 07:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MgMa6EJ46w+TjF/u1gN/gW9+ztz/QXzmUwMpKJQYIyo=;
        b=pyNfe8Xn4nvIZUJPkKZ3EaDZhM1x8wWbetMkTtOH0evncRwi4yKGLjXRdzWjQL+CGR
         zUU0rFXSeptYAzExzFvW5+hXf/mgKS+dwLmZL5MjnyEJlezTk5F+xWRqKbGGbiqg9+q9
         EouNtTLiuyHyjSqyEs9gJGIWlHCjyVFL6bBpg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MgMa6EJ46w+TjF/u1gN/gW9+ztz/QXzmUwMpKJQYIyo=;
        b=yXWT80p60jcRUn6VyQx19XHPync7uTcFa2XvJ5gComDO5nNrJOXaiJ4VghJMb76vQS
         u1Nv2ZVHKBK3hevzqewGwsJxsJ2Sp/hwRebGxJBH+tMMTfn3lvfJZ6Gi2w2QLNKkXdf/
         a+/DdyMzCP2K1gmox8bOjJ4vmz2VjA85+SoKKYUkIyvc4dJeVzndaccCQ7AYxtzXxi4L
         GZ8+mO29T6ttOJfACLFVk1lbnMVZID8pbTyCpsXZUTsdPWtWQmgSb1zLjJYkwAogoolR
         Qbagv01jJivfDOJjKvlf/rLfIV00A5TCETalpcacm4eznzNtNOUG9eOf0vakLZhFdEMx
         fyNw==
X-Gm-Message-State: AO0yUKUCVSygoU9my36qd2mWe4NnrddcwVIxaGP0xXs9pwb6IxMnyyKd
        Xg3XaQ8gGq65Jy+f7PZ1R2fl8vJmg4zrQVSFVOiDaA==
X-Google-Smtp-Source: AK7set+rq8teOzHKNYBPin6GVDaWwGDfSkNDQLU44vMY19ftzX6MLaAK4DBXIxvqGc9E5ohBKkFVnJp40DgTuL1DMUc=
X-Received: by 2002:a50:ab5a:0:b0:4ac:c453:6d5f with SMTP id
 t26-20020a50ab5a000000b004acc4536d5fmr1332039edc.8.1676475160544; Wed, 15 Feb
 2023 07:32:40 -0800 (PST)
MIME-Version: 1.0
References: <20230214171330.2722188-1-dhowells@redhat.com> <20230214171330.2722188-6-dhowells@redhat.com>
 <CAJfpegshWgUYZLc5v-Vwf6g3ZGmfnHsT_t9JLwxFoV8wPrvBnA@mail.gmail.com> <3367219.1676473410@warthog.procyon.org.uk>
In-Reply-To: <3367219.1676473410@warthog.procyon.org.uk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 15 Feb 2023 16:32:29 +0100
Message-ID: <CAJfpegtZXM7mOLbmc+si42iux+7E313QnRryztwT=U3g5Lqirw@mail.gmail.com>
Subject: Re: [PATCH v14 05/17] overlayfs: Implement splice-read
To:     David Howells <dhowells@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Hillf Danton <hdanton@sina.com>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>,
        John Hubbard <jhubbard@nvidia.com>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 15 Feb 2023 at 16:04, David Howells <dhowells@redhat.com> wrote:
>
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> > > +       ret = -EINVAL;
> > > +       if (in->f_flags & O_DIRECT &&
> > > +           !(real.file->f_mode & FMODE_CAN_ODIRECT))
> > > +               goto out_fdput;
> >
> > This is unnecessary, as it was already done in ovl_real_fdget() ->
> > ovl_real_fdget_meta() -> ovl_change_flags().
>
> Does that mean ovl_read_iter() and ovl_write_iter() shouldn't be doing it,
> then?

That's a different thing, because ovl_*_iter() are checking on
ki->flags, not f_flags.

Thanks,
Miklos
