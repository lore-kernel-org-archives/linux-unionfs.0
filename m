From: Vincent Bernat <bernat@luffy.cx>
Subject: Re: 9p/overlayfs: read error when reading an empty file
Date: Sat, 15 Aug 2015 13:57:41 +0200
Message-ID: <87bne8ix1m.fsf@zoro.exoscale.ch>
References: <87oai9hui2.fsf@zoro.exoscale.ch>
	<87fv3kiywt.fsf@zoro.exoscale.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from bart.luffy.cx ([78.47.78.131]:50630 "EHLO bart.luffy.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbbHOL5r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sat, 15 Aug 2015 07:57:47 -0400
In-Reply-To: <87fv3kiywt.fsf@zoro.exoscale.ch> (Vincent Bernat's message of
	"Sat, 15 Aug 2015 13:17:22 +0200")
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>, v9fs-developer@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

 =E2=9D=A6 15 ao=C3=BBt 2015 13:17 +0200, Vincent Bernat <bernat@luffy.=
cx>=C2=A0:

>> I have found a regression which was introduced after 4.0 in
>> 9p/overlayfs. This regression happens when the lower directory is a =
9p
>> mount, the upperdir is an empty tmpfs and we try to read 0 bytes fro=
m an
>> empty file (something than gcc is doing when trying to read an inclu=
de).
>>
>> The following program can be used to trigger the problem:
>>
>> #v+
>> #include <assert.h>
>> #include <sys/types.h>
>> #include <sys/stat.h>
>> #include <fcntl.h>
>> #include <unistd.h>
>>
>> int main(int argc, const char **argv)
>> {
>>     assert(argc =3D=3D 2);
>>     char buffer[256];
>>     int fd =3D open(argv[1], O_RDONLY|O_NOCTTY);
>>     assert(fd >=3D 0);
>>     assert(read(fd, buffer, 0) =3D=3D 0);
>>     return 0;
>> }
>> #v-
>>
>> read() returns -30720.
>>
>> This works fine with a 4.0 kernel and breaks with a 4.1 kernel.
>
> It took me some time to bissect this one because I also run into an
> infinite loop caused by 070b36 and fixed by 8e3c50. Finally, the culp=
rit
> for the above bug seems to be:
>
> commit e494b6b5e1034db00571c44e089e6fe3845b6e8c
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Wed Apr 1 23:59:57 2015 -0400
>
>     9p: switch to ->read_iter/->write_iter
>
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>
>
> This commit + 8e3c50 triggers the bug. This commit~1 + 8e3c50
> doesn't. Unfortunately, it is far too extensive to try to revert it o=
n
> top of 4.1.

After some more testing, I discovered that this bug also happens withou=
t
overlayfs (despite what I said in the first post). The fix is in fact
pretty easy (ret should be initialized to 0 in v9fs_file_read_iter). I
am sending a proper patch in a minute.
--=20
ROMEO:		Courage, man; the hurt cannot be much.
MERCUTIO:	No, 'tis not so deep as a well, nor so wide
			as a church-door; but 'tis enough, 'twill serve.
