From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC][PATCH 00/13] overlayfs stable inodes
Date: Wed, 19 Apr 2017 17:15:15 -0600
Message-ID: <940D64D5-55A8-45D1-844F-41872B2FEBB6@dilger.ca>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgtiDr9GEgjAsRHLeOo=HTobf-qwZ0bZLyjrhLyNiTt4A@mail.gmail.com>
 <CAJfpegsQTd8SgHRFcuEJMgjLjNW45vyuUiPPKZLC4bv_OJOmGA@mail.gmail.com>
 <CAOQ4uxh1VmeB1WGuP4sXyzR0oeQ_ux2hd+9vXM=UbsL+cxTwXQ@mail.gmail.com>
 <CAJfpegumzAZbvyWgfYaLtG1L7LF_Ob2zgA55Hz5H5Ctv7DoJ=Q@mail.gmail.com>
 <CAOQ4uxi0vRsyY2jrS_baaZ3n+d0Fx+6fDWj2Wm=4ZEGAZGHzDQ@mail.gmail.com>
 <CAJfpegsDMfM066PvoQup5SwS3exmfM23+2EWiUsuGROZvN3H_g@mail.gmail.com>
 <CAOQ4uxjWvgKr02-D-HwnGwrpoq165W++aOxddRUHhDFvv8bB7w@mail.gmail.com>
 <20170419225837.GE5205@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_76001317-E808-4AB0-AC85-0B5D739052E7";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33909 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938438AbdDSXPV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 19:15:21 -0400
Received: by mail-io0-f194.google.com with SMTP id h41so8683458ioi.1
        for <linux-unionfs@vger.kernel.org>; Wed, 19 Apr 2017 16:15:21 -0700 (PDT)
In-Reply-To: <20170419225837.GE5205@birch.djwong.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>


--Apple-Mail=_76001317-E808-4AB0-AC85-0B5D739052E7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 19, 2017, at 4:58 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Wed, Apr 19, 2017 at 06:17:15PM +0300, Amir Goldstein wrote:
>> On Wed, Apr 19, 2017 at 6:01 PM, Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>>> On Wed, Apr 19, 2017 at 4:46 PM, Amir Goldstein <amir73il@gmail.com> =
wrote:
>>>> Well, if you are lucky you can run into a filesystem that exports
>>>> a file handle of type FILEID_INO32_GEN, then you *know* you're
>>>> good to go. ext* will do that and xfs that was forever mounted with
>>>> -o inode32.
>>>> Even with xfs -o inode64, it will not use the MSB ino bits unless
>>>> you are in the exabytes fs sizes.
>=20
> I think it only takes really big AGs for it to start using the >32 bit =
parts.
>=20
>>>=20
>>> Could filesystems export a max-ino property in their sb?  That would
>>> help with doing this properly.
>>>=20
>>=20
>> Sounds reasonable, but as max-ino usually derived from filesystem =
size
>> and filesystems can grow size online, you will need to query both the
>> 'soft' ino limit (without growing fs) and the 'hard' ino limit.
>>=20
>> Darrick,
>>=20
>> Are there bits in GETFSMAP to provide this info?
>=20
> Nope.  I suppose there could be a way to find out the theoretical
> maximum inode number for a filesystem (statvfsx, etc.) but on the =
other
> hand I can also see the other fs developers not wanting to expose that
> information for fear that someone will start using the upper bits =
(inode
> numbers should just be a 64-bit cookie we hand to users, right?) and
> then they'll have to resort to all sorts of trickery to avoid breaking
> things if they ever /do/ want to use those high bits that have been
> claimed by someone else.

I recall there was a similar issue with GlusterFS assuming only 32-bit
readdir cookies on ext4, and stashing some information in the high bits,
but that broke when ext4 moved to 64-bit readdir cookies to avoid hash
collisions on "normal sized" directories (above ~32k entries).

I'd agree that it is the filesystem's prerogative to use any/all of the
64-bit inode number when it wants, and stacking filesystems shouldn't
try to usurp those bits for something else, only to suffer later on.

There is already some interest to add 64-bit inode numbers for ext4, and
it may allocate inode numbers sparsely, so just because the filesystem =
has
2^33 inodes in it doesn't imply that the highest possible inum is 2^33,
but could instead be 2^48 or something else entirely.

> /me wonders what you're trying to accomplish?

That is mentioned upthread:

>>>> On Wed, Apr 19, 2017 at 4:52 PM, Miklos Szeredi <miklos@szeredi.hu> =
wrote:

>>>>> I think we *can* do unified ino space even in
>>>>> most non-samefs cases.  And here's why: look at the inode numbers =
of
>>>>> any filesystem; they will always be "small" so we can just =
partition
>>>>> the 64 bit ino space between layers and map inode numbers into its =
own
>>>>> partition.  This does not work in the general case, and it is a =
hack.
>>>>> But it's a very simple hack and it probably works fine.

Cheers, Andreas






--Apple-Mail=_76001317-E808-4AB0-AC85-0B5D739052E7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY9++EpIg59Q01vtYRAp57AJ4moPd5cmUljJc6imUMD1x1GJoiNgCfcFIA
yz0Y1BuplKtU1CZNudJQPow=
=AHyZ
-----END PGP SIGNATURE-----

--Apple-Mail=_76001317-E808-4AB0-AC85-0B5D739052E7--
