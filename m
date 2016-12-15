From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] ovl: fix reStructuredText syntax errors in documentation
Date: Fri, 16 Dec 2016 08:12:04 +1100
Message-ID: <874m24yk0r.fsf@notabene.neil.brown.name>
References: <1481183391-30405-1-git-send-email-amir73il@gmail.com> <CAOQ4uxg8s_1ATqFFD6__2dez9-VYqR2NpFQ5iU8zvCDYLib0Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxg8s_1ATqFFD6__2dez9-VYqR2NpFQ5iU8zvCDYLib0Pw@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
List-Id: linux-unionfs@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Thu, Dec 15 2016, Amir Goldstein wrote:

> On Thu, Dec 8, 2016 at 9:49 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> - Fix broken long line block quote
>> - Fix missing newline before bullets list
>> - Use correct numbered list syntax
>>
>
> Ping.
>
> Neil,
> I found these syntax errors when I posted your page on my wiki:
> https://github.com/amir73il/overlayfs/wiki/Overlayfs-overview
>
> Not sure if this patch should go through Miklos's tree or John's tree,
> but is surely needs the ACK from you.

Does it?  It is purely format changes which don't change the meaning in
any way, so I felt it had little relevant to me.
However I'm happy to provide an:
  Acked-by: NeilBrown <neilb@suse.com>

if you find that useful.

NeilBrown

>
> Thanks,
> Amir.
>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  Documentation/filesystems/overlayfs.txt | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
>> index fb6f307..634d03e 100644
>> --- a/Documentation/filesystems/overlayfs.txt
>> +++ b/Documentation/filesystems/overlayfs.txt
>> @@ -66,7 +66,7 @@ At mount time, the two directories given as mount options "lowerdir" and
>>  "upperdir" are combined into a merged directory:
>>
>>    mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,\
>> -workdir=/work /merged
>> +  workdir=/work /merged
>>
>>  The "workdir" needs to be an empty directory on the same filesystem
>>  as upperdir.
>> @@ -118,6 +118,7 @@ programs.
>>
>>  seek offsets are assigned sequentially when the directories are read.
>>  Thus if
>> +
>>    - read part of a directory
>>    - remember an offset, and close the directory
>>    - re-open the directory some time later
>> @@ -137,12 +138,12 @@ When renaming a directory that is on the lower layer or merged (i.e. the
>>  directory was not created on the upper layer to start with) overlayfs can
>>  handle it in two different ways:
>>
>> -1) return EXDEV error: this error is returned by rename(2) when trying to
>> +1. return EXDEV error: this error is returned by rename(2) when trying to
>>     move a file or directory across filesystem boundaries.  Hence
>>     applications are usually prepared to hande this error (mv(1) for example
>>     recursively copies the directory tree).  This is the default behavior.
>>
>> -2) If the "redirect_dir" feature is enabled, then the directory will be
>> +2. If the "redirect_dir" feature is enabled, then the directory will be
>>     copied up (but not the contents).  Then the "trusted.overlay.redirect"
>>     extended attribute is set to the path of the original location from the
>>     root of the overlay.  Finally the directory is moved to the new
>> --
>> 2.7.4
>>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhTByUACgkQOeye3VZi
gbloQxAAvlc19O1mAfZ98Pn06ZK244BJ/NRrgedAkyNn82bQGHHKeCC5eB+dexZ3
4+Tx8W3pGnfvJ+Av1FIg1nAlsj5eX4c+vsqSZ3TQe7tcC5oAkNR6chb0ynl9IXEA
O9gG2zmC9hNEBcuYHcgPstWul4ZEu5IPm2yK0rEevZa7NoDbOF9Z3cNAquAiSR6m
DMsRMkzIhiSpm/bSYaJVgsr88HUTQ7p3OSmjzAxfiCfxVlXPIhIMh3WwS34e3QPn
h1ZucwzlqR5dyt1r76TEygUS5pgfeanXkUSrNl/+alLbZyy+mHKRUrmk73UDtY9I
+58KBziHtx7KcRM+sQBwAAonnuakpwTEX7/Uj4EQ4LcUzucEirsdSsBklwkPIUzi
Ch1RlDxT9ej3swCehgEV2dykslqd8h2WdFVpLmmfBiGsF9KmWg3zA4ZjPKDxxDBh
AwbbykzWZc9+mT23LTFeiY0A80QzWI+59Wa0IS1tpb8BO8+NooqqEepoAddADE3O
I0fLSzCx8TMK+v0er2qEy36+bInWjTAUONetqPZpoVFbnTdIvMiHz6qR8OL+jdcn
CVD1p7ArWmKqNXI4uVe8MI+LkqswNz+VqY29BW1r2pQ3S0RPfQS/rlgBd4YQerze
0UtsAaP8XlZXp13UoWezagCgGGKadMx3fjMBlxdua+6EGvW2IMI=
=a8ym
-----END PGP SIGNATURE-----
--=-=-=--
