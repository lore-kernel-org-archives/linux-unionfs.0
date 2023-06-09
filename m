Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62762C7EE25
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Jun 2023 13:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241287AbjFINPW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Jun 2023 09:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241293AbjFINPT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Jun 2023 09:15:19 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16AF132
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Jun 2023 06:15:14 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-97454836448so264778966b.2
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Jun 2023 06:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1686316513; x=1688908513;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O4lMbSF/WKw37kVGzYJN8z0LZRsxBdV16p4NHbZLues=;
        b=GnuhizAfo1jB5gx1HIPyhR7X8g/tc7i4cFhAWEi+g4yswEORfPkw1Wkxq1jLrcRmzO
         ZDuAX4QSdBbujRiRz3qhM0Z2ff/nSIIEthiZlKemoU3V29lXnZFAwkR5ak/1A5RAwVV1
         JHwBs8ZgKp6KxlNAbi2uJJ83CkJenkeyAxI18=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686316513; x=1688908513;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O4lMbSF/WKw37kVGzYJN8z0LZRsxBdV16p4NHbZLues=;
        b=VqQ7csrTdUGhCp6L76lCIqndkeLCkiHRBWmZ/dWWV59KUdiw8l+Q68h90P44cCibZ1
         WaBORR3hkKhCTAV4mnuWzmRyAaJ7DOlcF1AhuGXwG/OWEfrruIa6bQ97LQnPPoOu3+Xp
         aXN7niBP/JRNFDX67yxqi7SanqULyhj+gzDk+5sKiRWcFfd+jgKE66bgKxh6mcUE7kl3
         4pucX63Tkn3ZBWk3wzBfmDKg5Teydb6pgp5CJLgs7UdaHNc2Z3AMoi9ak2mnO49cQD92
         4MkzI9xMkGfcAE/Z0yzXiQi88DrbDYRkM8qPqcitvg1vuMLNB+fEBJ9h0izj8WcO7V2D
         lWZQ==
X-Gm-Message-State: AC+VfDyCA6YPTLU0Y79TBZwzMI/3UtvAb21/GTY/yo8i3r3UGdf3WtLh
        ZYfZooUC1MvGUQ2+x+3RCq/B6FrD80iIbmaiEetnVw==
X-Google-Smtp-Source: ACHHUZ7cblCrMkn0nLfqS/kCoNdDKaG/uM5PkAV7C69VJqJogllQr25QqHVSRD848NXXNOfd6XtOssymbkOKu+w9JL8=
X-Received: by 2002:a17:906:9b85:b0:96f:dd14:f749 with SMTP id
 dd5-20020a1709069b8500b0096fdd14f749mr1470541ejc.23.1686316513172; Fri, 09
 Jun 2023 06:15:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230609073239.957184-1-amir73il@gmail.com>
In-Reply-To: <20230609073239.957184-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 9 Jun 2023 15:15:01 +0200
Message-ID: <CAJfpegvDoSWPRaoa_i_Do3JDdaXrhohDtfQNObSJ7tNhhuHAKw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Reduce impact of overlayfs fake path files
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Paul Moore <paul@paul-moore.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 9 Jun 2023 at 09:32, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Miklos,
>
> This is the solution that we discussed for removing FMODE_NONOTIFY
> from overlayfs real files.
>
> My branch [1] has an extra patch for remove FMODE_NONOTIFY, but
> I am still testing the ovl-fsnotify interaction, so we can defer
> that step to later.
>
> I wanted to post this series earlier to give more time for fsdevel
> feedback and if these patches get your blessing and the blessing of
> vfs maintainers, it is probably better that they will go through the
> vfs tree.
>
> I've tested that overlay "fake" path are still shown in /proc/self/maps
> and in the /proc/self/exe and /proc/self/map_files/ symlinks.
>
> The audit and tomoyo use of file_fake_path() is not tested
> (CC maintainers), but they both look like user displayed paths,
> so I assumed they's want to preserve the existing behavior
> (i.e. displaying the fake overlayfs path).

I did an audit of all ->vm_file  and found a couple of missing ones:

dump_common_audit_data
ima_file_mprotect
common_file_perm (I don't understand the code enough to know whether
it needs fake dentry or not)
aa_file_perm
__file_path_perm
print_bad_pte
file_path
seq_print_user_ip
__mnt_want_write_file
__mnt_drop_write_file
file_dentry_name

Didn't go into drivers/ and didn't follow indirect calls (e.g.
f_op->fsysnc).  I also may have missed something along the way, but my
guess is that I did catch most cases.

Thanks,
Miklos
