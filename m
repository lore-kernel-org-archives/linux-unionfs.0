Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA0FEEB64D9
	for <linux-unionfs@archiver.kernel.org>; Sat, 17 Jun 2023 17:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbjFQRki (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 17 Jun 2023 13:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjFQRkh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 17 Jun 2023 13:40:37 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5B4CF
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 10:40:36 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id a1e0cc1a2514c-78f36f37e36so615506241.3
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 10:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687023635; x=1689615635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=skZ8Rt9NY7gObfpKi/EVYEg+Du7w4ujkJU4ra21m1aE=;
        b=cH0YjKc8S22B4y70weXAGyWP17w5aul3g/Ug+9E/EN1tqldJDUJZHwlm8EiNeMAiAm
         FE6jqPFHb6BalQ8weBposAQRMTTI4CTcrfUXrXZUnBkyUVRU/WxRO6gDm+vqS+G8XO63
         fLeKp0UNf20nL8Te//khP6TpvQewYZSs1QImZ9+SOCQyAbdFrlCnTD+IYpYiXWnxYxXM
         HlFzxLTssu0ECfpdkAihQU0/svAtqGJztCHunDfaAzeG/Oo5ECxJh6kfGB15dftmyXZh
         fL0PKl/wW7Pr7xOqLy9iSqT0cF9ZJnxkMK8pFqB4BnTNj6EhU6SJsT8ef0a1tPFE8e4d
         GDpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687023635; x=1689615635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=skZ8Rt9NY7gObfpKi/EVYEg+Du7w4ujkJU4ra21m1aE=;
        b=FrlMuOfSJBExs6Lp91PzFj3TUhnfeQ/fdSK6tTMSiZW08ailu6s8IK8sxFv340KE8S
         r0DRIAf7gxh85NXpv8KiAllS47XrdN8ZCf5aQWSMKuqRsC/jZWFyt7QPa55PJgyVrIeo
         DdvDmSCLuUQTGC5FtcD4OQN7o37Zb4f3B22QkeY6OCzdXMyjc5OvJQAWeqfgIPvaqk7v
         bOl6uzGdWOoG+kmW2JrVb2OSl5qcFQZc6QKEQisD78yjog1OX3BtVRwt03l7iUQvCqaH
         VrxtCPzoDU9tP65VlBIHqm+pfuJgSQBXp175lypH9UtOjPvPOKH2hsO7qpCn+C6DHbe5
         AkUw==
X-Gm-Message-State: AC+VfDwzf95TbCYA+TplmOQNT5Ie8bBnL9TlwGV6QrOX9veB4hPF/NVV
        HZ8KOXfis0yvRFO/ABUW4ppd3wfHZ76T7lnvSO4=
X-Google-Smtp-Source: ACHHUZ6briZt2snv+rc0IO+Yifwp4pGS9jsaa9u3E0wdKUUKVvyXpA/anMv2GyHL8mBQH6GmMPWpEKTbPUpVDkHfiKc=
X-Received: by 2002:a67:eb4c:0:b0:434:8c89:17f9 with SMTP id
 x12-20020a67eb4c000000b004348c8917f9mr1220945vso.20.1687023635501; Sat, 17
 Jun 2023 10:40:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com> <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
 <87h6s0z6rf.fsf@redhat.com> <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
 <CAL7ro1EoNDMxU2d9WYrb772VFWWMDWV=KVvrZDnK=5byemmo8Q@mail.gmail.com>
 <fb711bb4-3f25-ccee-0d21-2cb6deea75ec@linux.alibaba.com> <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
 <CAJfpegvsEuSNepb_9MNEkEFsW7R60DDk57x3oivA6wx9y8StRA@mail.gmail.com>
 <CAOQ4uxh14O9aRiewc+nq+AL-029YGu4bb4AZpp854r78Jm=_dw@mail.gmail.com>
 <CAJfpegvnBrLtNcW0Oy8Y7seju96scQ0-FHoiXxx3+A3X4N_LMQ@mail.gmail.com>
 <CAOQ4uxjPe5DBBFN5XfUPoYE1rKdbzTLsP9yOa2V9Ej4K8U4oEA@mail.gmail.com> <CAJfpegvnGe0e5Kp5hh6y4PES7xbr=LmgzOeXnFbBs9StcCou2g@mail.gmail.com>
In-Reply-To: <CAJfpegvnGe0e5Kp5hh6y4PES7xbr=LmgzOeXnFbBs9StcCou2g@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 17 Jun 2023 20:40:24 +0300
Message-ID: <CAOQ4uxjMOdSWhz0KPUanzM_UCyiQ6rMgNU4ouDsfmTN8X=+7Hg@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        Alexander Larsson <alexl@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 9, 2023 at 4:52=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> w=
rote:
>
> On Fri, 9 Jun 2023 at 15:42, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > Miklos,
> >
> > I see you pushed the branch as is.
> >
> > Please be warned that it contains the following unexplained
> > merge commit:
> >
> > commit b892fac09d57668181ff5c433958e96ec7755453
> > Merge: f1fcbaa18b28 7cdafe6cc4a6
> > Author: Amir Goldstein <amir73il@gmail.com>
> > Date:   Thu May 25 15:14:13 2023 +0300
> >
> >     Merge remote-tracking branch 'jack/fsnotify' into next
> >
> > And you know how Linus hates unexplained merge commits.
> >
> > In this case, it is unexplained and also does not have a
> > good reason in the context of an ovl pull request.
>
> Yes, I will redo this, but for getting into -next this will do.
>

Miklos,

I found a memory leak in these patches (reported by kmemleak).
For negative dentries, oe was allocated but not stored and not
freed.

Below is diff -w of the fix.
I squashed this fix into:
"ovl: move ovl_entry into ovl_inode"
and pushed the fixed overlayfs-next to my github [1]
I've also reabsed overlayfs-next onto 6.4-rc6.

Let me know if you want me to ask Steven to pull the fixed
branch into linux-next.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/fs-overlayfs-mount_api

--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -938,7 +938,7 @@ int ovl_maybe_lookup_lowerdata(struct dentry *dentry)
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
                          unsigned int flags)
 {
-       struct ovl_entry *oe;
+       struct ovl_entry *oe =3D NULL;
        const struct cred *old_cred;
        struct ovl_fs *ofs =3D dentry->d_sb->s_fs_info;
        struct ovl_entry *poe =3D OVL_E(dentry->d_parent);
@@ -1180,12 +1180,14 @@ struct dentry *ovl_lookup(struct inode *dir,
struct dentry *dentry,
                }
        }

+       if (ctr) {
                oe =3D ovl_alloc_entry(ctr);
                err =3D -ENOMEM;
                if (!oe)
                        goto out_put;

                ovl_stack_cpy(ovl_lowerstack(oe), stack, ctr);
+       }
