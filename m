Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:45833 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752660AbeEGSuO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 May 2018 14:50:14 -0400
Received: by mail-pl0-f66.google.com with SMTP id bi12-v6so349870plb.12
        for <linux-unionfs@vger.kernel.org>; Mon, 07 May 2018 11:50:13 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <4146D440-AE20-4BB2-AF6D-282A04A88516@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_07ECB7B1-9BDF-4A9C-9795-D19849AA1E20";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 3/3] ovl: Use splice_with_holes in copy_up
Date: Mon, 7 May 2018 12:50:07 -0600
In-Reply-To: <20180505231641.GF10363@dastard>
References: <20180503152635.14974-1-rgoldwyn@suse.de>
 <20180503152635.14974-4-rgoldwyn@suse.de>
 <CAOQ4uxhjhds4avkGBTHsqLp72nWjP=mAFPtxmUarcF1-jp89ng@mail.gmail.com>
 <20180503221142.GC10363@dastard>
 <8317eac5-d305-4bbd-5d93-4fa6801c8b6a@suse.de>
 <20180505231641.GF10363@dastard>
Sender: linux-unionfs-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Steve French <smfrench@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Anna Schumaker <Anna.Schumaker@netapp.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>


--Apple-Mail=_07ECB7B1-9BDF-4A9C-9795-D19849AA1E20
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On May 5, 2018, at 5:16 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, May 03, 2018 at 08:29:36PM -0500, Goldwyn Rodrigues wrote:
>> 
>> On 05/03/2018 05:11 PM, Dave Chinner wrote:
>>> 
>>> Yup, we want the copy offload infrastructure to be used if at all
>>> possible, so we get consistent behaviour for everyone trying to
>>> optimise copy behaviour.  In this case, I think that it is relevant
>>> that we heard at LSFMM that userspace utils don't want to use
>>> copy_file_range() because it doesn't "optimise for sparse files".
>>> 
>>> From that perspective, perhaps this needs "hole preserving copy"
>>> behaviour needs to be moved inside copy-file_range() (and therefore
>>> do_splice_direct()) and triggered by a new flag for
>>> copy_file_range(). e.g. COPY_FILE_SPARSE. That way callers can tell
>>> the kernel they want a sparse copy, and the kernel can attempt that
>>> rather a copy that converts holes to zeros.
>> 
>> In the patchset description [0], I ask if this should be the default
>> feature (I think it should be) and holes should be converted to zeros as
>> a special flag.. The only argument against it could be that applications
>> are already using this interface, so this would be a change in behavior.
> 
> In general, we don't change the behaviour of syscalls after the
> fact. We have flags to control behaviour, so applications that want
> to preserve holes will just have to be changed to use that flag.

It's hard to think of a normal use case where someone created a file with
holes, but wants the holes to be filled in when the file is copied...

The "cp" utility defaults to "--sparse=auto", but allows "--sparse=never"
to force hole filling, so it makes sense to handle the in-kernel copy
the same way.

Cheers, Andreas






--Apple-Mail=_07ECB7B1-9BDF-4A9C-9795-D19849AA1E20
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlrwn+AACgkQcqXauRfM
H+C+1A//SYEZfRYblGQxPeOocCadqAzvq9LNhNHxvoE2IG4jzyR8r/R01nFHWPu5
4gKgipP+TvWFnaAs55wIma5++HAPq3Cnedli8g1mbEb0nCWM8HZzJlUqWQGUp5gD
sthsi9CosQQm1JT1ITpTkU/GX2vYyE+qDchEC6ter1dctpYwknnZ76B9W1NrwZzX
RH7M+lbtZnWLsHm0dImVdtoUd7g9dORD5i4HKfIM1ReDTt2pnib1nmC3g1e9tuk7
D7f2psaHCZYRNEA6VHJpV4NVzFd9shy+jM4DL2TVS/6EH6AGsgYSFhkgsI3vq4es
4vPqtV2EjCWF0Bec1iVjT9fZboS9lkPwv4qGXIblxKMyxpAu0dHXLTwJjFfHISsn
aYzBKMNLwhrScJU1TL9Y6iTOdG+x9HLmAy2weh6YYP1Ps8HDZVLl0rG0Mr6r0sME
1TdExo8UknJDyr4inJX/Ek0RR65Flyr1KJTC/ujub2XBPOl2ocANu8wwZWt9TK0a
4cnHdL7yfG/qM3YA/CYNS1cQDA9TWCITUDllEJU5ftg48P0d2RgeFI8eQ7OoDfKr
qMSgP349SYDTPsApk1subs7umFSD1tpjhCui3hzUpIALmzQ2Nz1WTFE1riwvFmOC
g2gq0HRskbb3LHknWHGafyZZEKdofTREexXVrOX8zcVd7Cflvfo=
=XXf4
-----END PGP SIGNATURE-----

--Apple-Mail=_07ECB7B1-9BDF-4A9C-9795-D19849AA1E20--
