From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [overlay] what's the purpose for setting RENAME_EXCHANGE when
 dest is WHITEOUT dev
Date: Thu, 5 Mar 2015 17:44:12 +0100
Message-ID: <CAJfpeguey4HUHU6HZ9KJB7YMbZbrEt5VX8NV5AebVGsqbxd=7A@mail.gmail.com>
References: <CAPBX1xLSso+PnADdy-r=M_+reHG86=C+ohVU3ddM60P2DxeV_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:37405 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbbCEQoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 5 Mar 2015 11:44:14 -0500
Received: by mail-qa0-f46.google.com with SMTP id n4so39916220qaq.5
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Mar 2015 08:44:12 -0800 (PST)
In-Reply-To: <CAPBX1xLSso+PnADdy-r=M_+reHG86=C+ohVU3ddM60P2DxeV_Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: =?UTF-8?B?546L5pet?= <xuw2015@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Feb 5, 2015 at 11:01 AM, =E7=8E=8B=E6=97=AD <xuw2015@gmail.com>=
 wrote:
> Hi,
>   I read the source code of overlay fs, it's amazing, but a few
> confusion for the rename2 function.
>
>   Here is the code:
> 799     if (overwrite) {
>
> 800         if (old_opaque) {
> 801             if (new->d_inode || !new_opaque) {
> 802                 /* Whiteout source */
> 803                 flags |=3D RENAME_WHITEOUT;
> 804             } else {
> 805                 /* Switch whiteouts */
> 806                 flags |=3D RENAME_EXCHANGE;
> 807             }
> 808         } else if (is_dir && !new->d_inode && new_opaque) {
> 809             flags |=3D RENAME_EXCHANGE;
>                   ^^^^^^^^^^Is necessary to use RENAME_EXCHANGE? why
> not let vfs_rename to remove the new(dest) entry?

Source is a directory, dest is a whiteout represented by a chardev.
There's a rule that directory can only overwrite directory and
non-directory can only overwrite non-directory.

Thanks,
Miklos
--
To unsubscribe from this list: send the line "unsubscribe linux-unionfs=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
