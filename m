Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B951C001E0
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Aug 2023 19:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjHOTJK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 15 Aug 2023 15:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238615AbjHOTIl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Aug 2023 15:08:41 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3267810E3
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2023 12:08:14 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9936b3d0286so811015966b.0
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2023 12:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1692126477; x=1692731277;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SyVR5zWYy10iACB/nQEnNcZZ/v1zi8XZ/0R3Kx+8hos=;
        b=ZLQ2XW/FXySLBU9HHltQ+i2WReyg3wws1yfumgQRb3yZtSKdT3ccGR3I5ydZwxUq26
         VVg7JtsQEQfvmIVsDNXGgpfqc0rjeC1jlWo25SBc0gnkgq2u4EzN0lO6vYDYIE3oo/VR
         r1YHCwjNooDm3kwhCi9w2Bu876YnJIgzkgYsQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692126477; x=1692731277;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SyVR5zWYy10iACB/nQEnNcZZ/v1zi8XZ/0R3Kx+8hos=;
        b=OWg95OX/qikYLXkamyfROkhBXHNaKZvoHbj9oZ7jgB1o7arPzM4VujMdgEYYXUCyDQ
         oR2U4aftKwgOtThIWUZd/7Jj8ioZC/S6pmW3bdUFUAURsA8q96KywmSsuIvZmqsNMsGb
         6ctRhMCFekGMU5Vi7LERNIZdtW2luSpojkyu8yXcoL0JHB5/5N6ZMX3eW/Q9Y/N/i7Q6
         gh3wUMI9oOsk603QAJ7tZ5K532AYe2+nR8oEctFIGHv7Sh1o5eMSNbFchYMbrEMqnWtw
         Yto6N6OngFlurpsAG4Az1cCeSX35o4zH1JwDF73IyKOWRrPUo5LEM7DtFspJepZu3xn4
         JI0A==
X-Gm-Message-State: AOJu0YwbPcQ91pmfO7to/0jooKZgqtidjaR7pifnG4atoOieb00okPwC
        y+0YUvk3aAg2yWCw8kWy2Vt7aU+iSYZ2mcQcldv/ow==
X-Google-Smtp-Source: AGHT+IEOeDAIK2MCQgBVIsa5UUR72/cxulT64IW5/Gn/pAgQw+Gh8TdjxChSy27aL9dZknwmvf1egrtIyidFo4BJpAo=
X-Received: by 2002:a17:906:9bce:b0:99d:e858:4160 with SMTP id
 de14-20020a1709069bce00b0099de8584160mr148410ejc.49.1692126476815; Tue, 15
 Aug 2023 12:07:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230814140518.763674-1-amir73il@gmail.com> <20230814140518.763674-3-amir73il@gmail.com>
 <CAJfpegu=-+jA1026KoqrFBX9dsfvQbcjHbkNunkZ6A794mZ1TQ@mail.gmail.com> <CAOQ4uxiTtraLVdsKJdty6z89=Lm52DGHFf1i_aL9jQz3L80V9Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxiTtraLVdsKJdty6z89=Lm52DGHFf1i_aL9jQz3L80V9Q@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 15 Aug 2023 21:07:45 +0200
Message-ID: <CAJfpegudye=2e2BWtk+fmaKMN_vUnwsKM8fi-GPcEX5n_vEizQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ovl: do not open/llseek lower file with upper
 sb_writers held
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 15 Aug 2023 at 17:59, Amir Goldstein <amir73il@gmail.com> wrote:

> > What occurs to me is why are we bothering with getting write access on
> > the internal upper mnt each time.  Seems to me it's a historical thing
> > without a good reason.  Upper mnt is never changed from R/W to R/O.
> >
> > So the only thing we need to do is grab the upper mount write access
> > on superblock creation and do the sb_start_write/end_write() thing
> > which can't fail.  If upper mnt is read-only, we effectively have a
> > read-only filesystem, and can handle it that way (sb->s_flags |=
> > SB_RDONLY).
> >
> > There's still the possibility that we do some changes to upper even
> > for non-modify operations.  But with careful review we can remove a
> > most (possibly all) error handling cases from ovl_want_write()
> > callsites when we do know that we have write access on upper.  And
> > WARN_ON(__mnt_is_readonly(ovl_upper_mnt(ofs))) should ensure that we
> > catch any mistakes.
> >
> > Hmm?
> >
>
> I was thinking the same thing myself, before I went on this journey.
> I reached the conclusion that doing only sb_start_write() would not be
> safe against emergency remount rdonly of the upper sb.
>
> I guess if upper sb is emergency mounted rdonly, then overlayfs
> sb would also be emergency remounted rdonly, but for example
> ext4 sb can become rdonly on internal errors.
> But maybe that is not the responsibility of vfs or ovl to care about?

Consider the case of a writable open file: the mount write access is
only checked on open.  So not having fine grained mnt write access
checks is not without precedent.

I'm not sure, but the number of added lines in this particular patch
makes me think that at least during copy-up we could separate the mnt
and the sb write locks.

> Christian, is there also an API to set the sb rdonly when private
> writable mounts (i.e. ovl_upper_mnt) exist?

You mean notifying overlayfs about rdonly remount of upper mnt?  No,
that doesn't exist today.

Thanks,
Miklos
