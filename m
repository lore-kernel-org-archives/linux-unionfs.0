From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH] ovl: fix overlay: warning prefix
Date: Wed, 10 Jan 2018 19:59:32 +0800
Message-ID: <F4A79EBD-8856-4383-827A-6FBA7B08B608@icloud.com>
References: <1515575854-67252-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxgR-Srh5_9sK1o+NZW=0beWNbiF8BM4nF434sx0dL0Pkw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:29355 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932218AbeAJMAS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Jan 2018 07:00:18 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp002.me.com by
 pv33p36im-asmtp002.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2C0060098W4U00@pv33p36im-asmtp002.me.com> for
 linux-unionfs@vger.kernel.org; Wed, 10 Jan 2018 11:59:42 +0000 (GMT)
In-reply-to: <CAOQ4uxgR-Srh5_9sK1o+NZW=0beWNbiF8BM4nF434sx0dL0Pkw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2018=C4=EA1=D4=C210=C8=D5=A3=AC=CF=C2=CE=E77:45=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Wed, Jan 10, 2018 at 11:17 AM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>> Conform one stray warning message to the standard overlayfs: prefix.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>> ---
>> fs/overlayfs/namei.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>> index beb945e..d0a801b 100644
>> --- a/fs/overlayfs/namei.c
>> +++ b/fs/overlayfs/namei.c
>> @@ -693,7 +693,7 @@ struct dentry *ovl_lookup(struct inode *dir, =
struct dentry *dentry,
>>                 */
>>                err =3D -EPERM;
>>                if (d.redirect && !ofs->config.redirect_follow) {
>> -                       pr_warn_ratelimited("overlay: refusing to =
follow redirect for (%pd2)\n", dentry);
>> +                       pr_warn_ratelimited("overlayfs: refusing to =
follow redirect for (%pd2)\n", dentry);
>>                        goto out_put;
>>                }
>>=20
>> --
>=20
>=20
> I already posted this fix, but as long as the fix gets merged=A1=AD

Sorry, I didn=A1=AFt check very closely=A3=ACplease apply in your patch.


Thanks,
Chengguang.
