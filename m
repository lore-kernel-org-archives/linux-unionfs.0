Return-Path: <SRS0=5TWu=5O=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9ADC43331
	for <linux-unionfs@archiver.kernel.org>; Sun, 29 Mar 2020 14:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E4E6206F6
	for <linux-unionfs@archiver.kernel.org>; Sun, 29 Mar 2020 14:21:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="d94F4Yjk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgC2OVh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 29 Mar 2020 10:21:37 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21115 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727488AbgC2OVg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 29 Mar 2020 10:21:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1585491545;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=dZo5OJf4GKWzxmdinmo47gCbSPNnqkzy5hp0LxzJGE0=;
        b=d94F4YjkRAK8CZiKzkmBWsKXGdp3Dv7NZT7rg0O95O0OeyaKoFioX31MjzQOh3Cq
        vCD+EOOY0k0hsBvXPsqqftHsLxjbDKkTHZmMc0GkSyhugKj6SoXFbdLfErwy+SUGQuW
        6NO+JgaY3hKTQw9hbd+O82cuk+6aPkLoA6TwHgjI=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1585491542927621.0381486166795; Sun, 29 Mar 2020 22:19:02 +0800 (CST)
Date:   Sun, 29 Mar 2020 22:19:02 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "linux-unionfs" <linux-unionfs@vger.kernel.org>,
        "miklos" <miklos@szeredi.hu>
Message-ID: <17126a9038c.d17770b728105.8827100903005997785@mykernel.net>
In-Reply-To: <CAOQ4uxj-6upXZkAKVDocuLSwveO8hb5_pdbd=_0zbRx2UD9gsg@mail.gmail.com>
References: <171155f7fb1.fb0dc6a422928.8465401279980458758@mykernel.net>
 <CAOQ4uxgAubW72xGej-Tg4juicRe3nY0gmH32p0Sf3OWV45fviA@mail.gmail.com> <1711a6d7ebf.1251ea7b024963.4823296748033142049@mykernel.net> <CAOQ4uxj-6upXZkAKVDocuLSwveO8hb5_pdbd=_0zbRx2UD9gsg@mail.gmail.com>
Subject: Re: Inode limitation for overlayfs
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Priority: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2020-03-27 17:45:37 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Fri, Mar 27, 2020 at 8:18 AM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-03-26 15:34:13 Amir =
Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > On Thu, Mar 26, 2020 at 7:45 AM Chengguang Xu <cgxu519@mykernel.net=
> wrote:
 > >  > >
 > >  > > Hello,
 > >  > >
 > >  > > On container use case, in order to prevent inode exhaustion on ho=
st file system by particular containers,  we would like to add inode limita=
tion for containers.
 > >  > > However,  current solution for inode limitation is based on proje=
ct quota in specific underlying filesystem so it will also count deleted fi=
les(char type files) in overlay's upper layer.
 > >  > > Even worse, users may delete some lower layer files for getting m=
ore usable free inodes but the result will be opposite (consuming more inod=
es).
 > >  > >
 > >  > > It is somewhat different compare to disk size limitation for over=
layfs, so I think maybe we can add a limit option just for new files in ove=
rlayfs. What do you think?
 >=20
 > You are saying above that the goal is to prevent inode exhaustion on
 > host file system,
 > but you want to allow containers to modify and delete unlimited number
 > of lower files
 > thus allowing inode exhaustion. I don't see the logic is that.
 >=20

End users do not understand kernel tech very well, so we just want to mitig=
ate
container's different user experience as much as possible. In our point of =
view,=20
consuming more inode by deleting lower file is the feature of overlayfs, it=
's not
caused by user's  abnormal using. However, we have to limit malicious user
program which is endlessly creating new files until host inode exhausting.


 > Even if we only count new files and present this information on df -i
 > how would users be able to free up inodes when they hit the limit?
 > How would they know which inodes to delete?
 >=20
 > >  >
 > >  > The questions are where do we store the accounting and how do we ma=
intain them.
 > >  > An answer to those questions could be - in the inode index:
 > >  >
 > >  > Currently, with nfs_export=3Don, there is already an index dir cont=
aining:
 > >  > - 1 hardlink per copied up non-dir inode
 > >  > - 1 directory per copied-up directory
 > >  > - 1 whiteout per whiteout in upperdir (not an hardlink)
 > >  >
 > >
 > > Hi Amir,
 > >
 > > Thanks for quick response and detail information.
 > >
 > > I think the simplest way is just store accounting info in memory(maybe=
  in s_fs_info).
 > > At very first, I just thought  doing it for container use case, for co=
ntainer, it will be
 > > enough because the upper layer is always empty at starting time and wi=
ll be destroyed
 > > at ending time.
 >=20
 > That is not a concept that overlayfs is currently aware of.
 > *If* the concept is acceptable and you do implement a feature intended f=
or this
 > special use case, you should verify on mount time that upperdir is empty=
.
 >=20
 > >
 > > Adding a meta info to index dir is a  better solution for general use =
case but it seems
 > > more complicated and I'm not sure if there are other use cases concern=
 with this problem.
 > > Suggestion?
 >=20
 > docker already supports container storage quota using project quotas
 > on upperdir (I implemented it).
 > Seems like a very natural extension to also limit no. of inodes.
 > The problem, as you wrote it above is that project quotas
 > "will also count deleted files(char type files) in overlay's upper layer=
."
 > My suggestion to you was a way to account for the whiteouts separately,
 > so you may deduct them from total inode count.
 > If you are saying my suggestion is complicated, perhaps you did not
 > understand it.
 >=20

I think the key point here is the count of whiteout inode. I would like to
propose share same inode with different whiteout files so that we can save
inode significantly for whiteout files. After this, I think we can just imp=
lement
normal inode limit for container just like block limit.


 > >
 > >
 > >  > We can also make this behavior independent of nfs_export feature.
 > >  > In the past, I proposed the option index=3Dall for this behavior.
 > >  >
 > >  > On mount, in ovl_indexdir_cleanup(), the index entries for file/dir=
/whiteout
 > >  > can be counted and then maintained on index add/remove.
 > >  >
 > >  > Now if you combine that with project quotas on upper/work dir, you =
get:
 > >  > <Total upper/work inodes> =3D <pure upper inodes> + <non-dir index =
count> +
 > >  >                                            2*<dir index count> +
 > >  > 2*<whiteout index count>
 > >
 > > I'm not clear what the exact relationships between those indexes and n=
fs_export
 >=20
 > nfs_export feature reuiqres index_all, but we did not have a reason (yet=
) to
 > add an option to enable index_all without enabling nfs_export:
 >=20
 > /* Index all files on copy up. For now only enabled for NFS export */
 > bool ovl_index_all(struct super_block *sb)
 > {
 >         struct ovl_fs *ofs =3D sb->s_fs_info;
 >=20
 >         return ofs->config.nfs_export && ofs->config.index;
 > }
 >=20
 > > but  if possible I hope having  separated switches for every index fun=
ctions and a total
 > > switch(index=3Dall) to enable all index functions at same time.
 > >
 >=20
 > FYI, index_all stands for "index all modified/deleted lower files (and d=
irs)"
 > At the moment, the only limitation of nfs_export=3Don that could be rela=
xed with
 > index=3Dall is that nfs_export=3Don is mutually exclusive with metacopy=
=3Don.
 > index=3Dall will not have this limitation.
 >=20
 > >  >
 > >  > Assuming that you know the total from project quotas and the index =
counts
 > >  > from overlayfs, you can calculate total pure upper.
 > >  >
 > >  > Now you *can* implement upper inodes quota within overlayfs, but yo=
u
 > >  > can also do that without changing overlayfs at all assuming you can
 > >  > allow some slack in quota enforcement -
 > >  > periodically scan the index dir and adjust project quota limits.
 > >
 > > Dynamically changing inode limit  looks  too complicated to implement =
in management system
 > > and having different quota limit during lifetime for same container ma=
y cause confusion to sys admins.
 > > So I still hope to solve this problem on overlayfs layer.
 > >
 >=20
 > To me that sounds like shifting complexity from system to kernel
 > for not a good enough reason and with loosing flexibility.
 > You are proposing a heuristic solution anyway because it is inherently
 > not immune against DoS of a malicious container that does rm -rf *.
 > So to me it makes more sense to deal with that logic in container
 > management level, where more heuristics can be applied, for example:
 > Allow to add up to X new files, modify %Y files from lower and
 > delete %Z files from lower.
 >=20
 > Note that container management does not have to adjust project quota
 > limits periodically, it only needs to re-calculate and adjust project qu=
ota
 > limits when user gets out of quota warning.
 > I believe there are already mechanisms in Linux quota management to
 > notify management software of quota limit expiry in order to take action=
,
 > but I am not that familiar with those mechanisms.
 >=20

If overlayfs could export statistical information(whiteout count, etc.. ) t=
o user space,
it will be very helpful and easy to implement based on the detail informati=
on.


Thanks,
cgxu


