From: Ignacy =?iso-8859-2?Q?Gaw=EAdzki?=
	<ignacy.gawedzki@green-communications.fr>
Subject: Re: [PATCH 1/1] OverlayFS: Fix checking permissions during lookup.
Date: Fri, 5 Feb 2016 13:29:13 +0100
Message-ID: <20160205122913.GA1992@zenon.in.qult.net>
References: <20160126083834.GB18883@zenon.in.qult.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from str75-3-78-193-33-39.fbxo.proxad.net ([78.193.33.39]:33421 "EHLO
	mail.qult.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbcBEM3R (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 5 Feb 2016 07:29:17 -0500
Received: from zenon.in.qult.net ([192.168.64.1])
	by mail.qult.net with esmtps (TLS1.2:RSA_AES_128_CBC_SHA1:128)
	(Exim 4.82)
	(envelope-from <ignacy.gawedzki@green-communications.fr>)
	id 1aRfVk-0003pv-El
	for linux-unionfs@vger.kernel.org; Fri, 05 Feb 2016 13:29:16 +0100
Received: from ig by zenon.in.qult.net with local (Exim 4.86)
	(envelope-from <ignacy.gawedzki@green-communications.fr>)
	id 1aRfVh-0000fZ-EH
	for linux-unionfs@vger.kernel.org; Fri, 05 Feb 2016 13:29:13 +0100
Content-Disposition: inline
In-Reply-To: <20160126083834.GB18883@zenon.in.qult.net>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

On Tue, Jan 26, 2016 at 09:38:34AM +0100, thus spake Ignacy Gawedzki:
> Add alternate lookup_one_len_check function to fs/namei.c which does
> what lookup_one_len did until now with a boolean argument telling
> whether to check that the base directory is traversable.  Modify
> original lookup_one_len function to call the former with true as the
> last argument.
>=20
> In function ovl_lookup_real, file fs/overlayfs/super.c, call
> lookup_one_len_check with false as the last argument, so that failure
> to traverse the base directory does not return -EACCES.  This should
> make lookup resolution work properly in the following setup
>=20
>   drwxr-xr-x lower/
>   drwx------ lower/foo/
>   drw-r--r-- lower/boo/bar
>   drwxr-xr-x upper/
>   drwxr-xr-x upper/foo/
>=20
> when any user not being the owner of lower/foo is trying to access
> foo/bar in the mounted overlay.

Hi everyone,

Please forgive my insisting, but I'm really looking forward to seeing
some confirmation that this is the right way to go.

Could someone take a look at this patch and confirm this is not going
to wreak havoc?

Thanks.

Ignacy

--=20
Ignacy Gaw=EAdzki
R&D Engineer
Green Communications
