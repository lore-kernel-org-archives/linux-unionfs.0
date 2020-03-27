Return-Path: <SRS0=Y+g3=5M=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6574EC43331
	for <linux-unionfs@archiver.kernel.org>; Fri, 27 Mar 2020 09:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F15A206F2
	for <linux-unionfs@archiver.kernel.org>; Fri, 27 Mar 2020 09:45:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZQ7HZnSI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgC0Jpu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 05:45:50 -0400
Received: from mail-il1-f175.google.com ([209.85.166.175]:41521 "EHLO
        mail-il1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgC0Jpu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 27 Mar 2020 05:45:50 -0400
Received: by mail-il1-f175.google.com with SMTP id t6so4547359ilj.8
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Mar 2020 02:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C02+IqFxBSeyepAwX0BVV9k1b37zV46qnGWoMxDtotQ=;
        b=ZQ7HZnSIYvvOWKmSrxqb1sHwyEt7MbiF0pbCzWd0GGJIeH/ZpTQZWObEG3jqjj9Gjb
         NWhck/CnzIRlk59yUietjuPjJqJVomQYYNBWXzqJrPhImjWqkuAXaAte0+MGzhgN7pxw
         fT/2RTIY9652S2vhTGlDinBDvNgUtsvGQ7iIBAdr62IotL+SYjT4eJ9YbFJ5g7YO0tZG
         OeqLTgqCKBE3OB9HWHo/2HIkvkAR5GjPzPo4mdQjyrj0fUImbDKzgUkOxE4LFc0OUPG2
         +Zd6E1BCgw5LgWTlPt9iMH5oR2OEJvVt3YtrsL5mLqPdJfXdXaOBzImKHq8zbmyBUFkW
         K/MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C02+IqFxBSeyepAwX0BVV9k1b37zV46qnGWoMxDtotQ=;
        b=RbLNh5BzDAyhz8f3X19bZqxhrvsi6y/envj0Mt1qfGkcF+Ks2Jf4izBWtFTlqGGyI/
         05+1cuUXkwBCySFdOz26Y13dxdudtwHePtyUToHJO7TTU5ujvsbZGe/8WsHGaH0M/no1
         cuk/cqZyWqUp9ZH1MxeoZG7wnOHXpU6Cf7cPSDb1ZZFPIqcghvCzov7GrbhHw9Q/k/b2
         ZZKeHfCd/QF0dGOSYg9jqBm2kIvRA+8k7Nqp+vZjQLEATqKT3Xv+bLEChDsjcWtB+FKr
         pKwcCXXXq5pnckxH+w8d1Y82taM4wxsK9K0Z9VHLOS0IZj62NndVLWUt7Nvmc3xAdjKQ
         hPaA==
X-Gm-Message-State: ANhLgQ2d/hq+Ytrmi+WxD+TvaYlcJWNmCqcf5r96WjjGebQN1vSlk0k9
        yhFQLjqGhgbOGaqN8KDjNvXUaToAuBS82Pa7HE+HA990
X-Google-Smtp-Source: ADFU+vslzwr8DgO7jMbnp3LxbP66CGeXQI8e05i5okuIkufHiWHc5OlQ28PyRKg7/Qp0lUl/S5FmrI7Rfzm7l2WK0R8=
X-Received: by 2002:a92:5b51:: with SMTP id p78mr12669800ilb.250.1585302348722;
 Fri, 27 Mar 2020 02:45:48 -0700 (PDT)
MIME-Version: 1.0
References: <171155f7fb1.fb0dc6a422928.8465401279980458758@mykernel.net>
 <CAOQ4uxgAubW72xGej-Tg4juicRe3nY0gmH32p0Sf3OWV45fviA@mail.gmail.com> <1711a6d7ebf.1251ea7b024963.4823296748033142049@mykernel.net>
In-Reply-To: <1711a6d7ebf.1251ea7b024963.4823296748033142049@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 27 Mar 2020 12:45:37 +0300
Message-ID: <CAOQ4uxj-6upXZkAKVDocuLSwveO8hb5_pdbd=_0zbRx2UD9gsg@mail.gmail.com>
Subject: Re: Inode limitation for overlayfs
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     linux-unionfs <linux-unionfs@vger.kernel.org>,
        miklos <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Mar 27, 2020 at 8:18 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-03-26 15:34:13 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Thu, Mar 26, 2020 at 7:45 AM Chengguang Xu <cgxu519@mykernel.net> w=
rote:
>  > >
>  > > Hello,
>  > >
>  > > On container use case, in order to prevent inode exhaustion on host =
file system by particular containers,  we would like to add inode limitatio=
n for containers.
>  > > However,  current solution for inode limitation is based on project =
quota in specific underlying filesystem so it will also count deleted files=
(char type files) in overlay's upper layer.
>  > > Even worse, users may delete some lower layer files for getting more=
 usable free inodes but the result will be opposite (consuming more inodes)=
.
>  > >
>  > > It is somewhat different compare to disk size limitation for overlay=
fs, so I think maybe we can add a limit option just for new files in overla=
yfs. What do you think?

You are saying above that the goal is to prevent inode exhaustion on
host file system,
but you want to allow containers to modify and delete unlimited number
of lower files
thus allowing inode exhaustion. I don't see the logic is that.

Even if we only count new files and present this information on df -i
how would users be able to free up inodes when they hit the limit?
How would they know which inodes to delete?

>  >
>  > The questions are where do we store the accounting and how do we maint=
ain them.
>  > An answer to those questions could be - in the inode index:
>  >
>  > Currently, with nfs_export=3Don, there is already an index dir contain=
ing:
>  > - 1 hardlink per copied up non-dir inode
>  > - 1 directory per copied-up directory
>  > - 1 whiteout per whiteout in upperdir (not an hardlink)
>  >
>
> Hi Amir,
>
> Thanks for quick response and detail information.
>
> I think the simplest way is just store accounting info in memory(maybe  i=
n s_fs_info).
> At very first, I just thought  doing it for container use case, for conta=
iner, it will be
> enough because the upper layer is always empty at starting time and will =
be destroyed
> at ending time.

That is not a concept that overlayfs is currently aware of.
*If* the concept is acceptable and you do implement a feature intended for =
this
special use case, you should verify on mount time that upperdir is empty.

>
> Adding a meta info to index dir is a  better solution for general use cas=
e but it seems
> more complicated and I'm not sure if there are other use cases concern wi=
th this problem.
> Suggestion?

docker already supports container storage quota using project quotas
on upperdir (I implemented it).
Seems like a very natural extension to also limit no. of inodes.
The problem, as you wrote it above is that project quotas
"will also count deleted files(char type files) in overlay's upper layer."
My suggestion to you was a way to account for the whiteouts separately,
so you may deduct them from total inode count.
If you are saying my suggestion is complicated, perhaps you did not
understand it.

>
>
>  > We can also make this behavior independent of nfs_export feature.
>  > In the past, I proposed the option index=3Dall for this behavior.
>  >
>  > On mount, in ovl_indexdir_cleanup(), the index entries for file/dir/wh=
iteout
>  > can be counted and then maintained on index add/remove.
>  >
>  > Now if you combine that with project quotas on upper/work dir, you get=
:
>  > <Total upper/work inodes> =3D <pure upper inodes> + <non-dir index cou=
nt> +
>  >                                            2*<dir index count> +
>  > 2*<whiteout index count>
>
> I'm not clear what the exact relationships between those indexes and nfs_=
export

nfs_export feature reuiqres index_all, but we did not have a reason (yet) t=
o
add an option to enable index_all without enabling nfs_export:

/* Index all files on copy up. For now only enabled for NFS export */
bool ovl_index_all(struct super_block *sb)
{
        struct ovl_fs *ofs =3D sb->s_fs_info;

        return ofs->config.nfs_export && ofs->config.index;
}

> but  if possible I hope having  separated switches for every index functi=
ons and a total
> switch(index=3Dall) to enable all index functions at same time.
>

FYI, index_all stands for "index all modified/deleted lower files (and dirs=
)"
At the moment, the only limitation of nfs_export=3Don that could be relaxed=
 with
index=3Dall is that nfs_export=3Don is mutually exclusive with metacopy=3Do=
n.
index=3Dall will not have this limitation.

>  >
>  > Assuming that you know the total from project quotas and the index cou=
nts
>  > from overlayfs, you can calculate total pure upper.
>  >
>  > Now you *can* implement upper inodes quota within overlayfs, but you
>  > can also do that without changing overlayfs at all assuming you can
>  > allow some slack in quota enforcement -
>  > periodically scan the index dir and adjust project quota limits.
>
> Dynamically changing inode limit  looks  too complicated to implement in =
management system
> and having different quota limit during lifetime for same container may c=
ause confusion to sys admins.
> So I still hope to solve this problem on overlayfs layer.
>

To me that sounds like shifting complexity from system to kernel
for not a good enough reason and with loosing flexibility.
You are proposing a heuristic solution anyway because it is inherently
not immune against DoS of a malicious container that does rm -rf *.
So to me it makes more sense to deal with that logic in container
management level, where more heuristics can be applied, for example:
Allow to add up to X new files, modify %Y files from lower and
delete %Z files from lower.

Note that container management does not have to adjust project quota
limits periodically, it only needs to re-calculate and adjust project quota
limits when user gets out of quota warning.
I believe there are already mechanisms in Linux quota management to
notify management software of quota limit expiry in order to take action,
but I am not that familiar with those mechanisms.

Thanks,
Amir.
