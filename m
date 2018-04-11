MIME-Version: 1.0
In-Reply-To: <C665F64A-11F7-4F6F-82D4-8F287A983E30@gmx.com>
References: <779D1CE1-7805-4026-BC7D-3773D5E37B34@gmx.com>
	<CAOQ4uxjuO8ZUH_9Y68-y0JQsF9yunTarF6YFCtSW20V_EjXUFA@mail.gmail.com>
	<C665F64A-11F7-4F6F-82D4-8F287A983E30@gmx.com>
Date: Wed, 11 Apr 2018 09:17:15 +0200
Message-ID: <CAJfpegvLerH4J_zzXCMHOhbuwJT5-NYZiY91Dnc1GAUyKTu8zA@mail.gmail.com>
Subject: Re: question of copying stack in ovl_lookup()
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "cgxu519@gmx.com" <cgxu519@gmx.com>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 11, 2018 at 7:41 AM, cgxu519@gmx.com <cgxu519@gmx.com> wrote:
>
>> =E5=9C=A8 2018=E5=B9=B44=E6=9C=8810=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=881=
:38=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>
>> On Tue, Apr 10, 2018 at 4:29 AM, cgxu519@gmx.com <cgxu519@gmx.com> wrote=
:
>>> Hi guys,
>>>
>>> I=E2=80=99m a little curious for below code in ovl_lookup, is there any=
 background for
>>> copy stack instead of directly using it?
>>>
>>> memcpy(oe->lowerstack, stack, sizeof(struct ovl_path) * ctr);
>>>
>>
>> Memory compaction.
>>
>> stack has ofs->numlower entries, which could be very large,
>> but after lookup, oe->numlower can end up being much much
>> smaller. Also, ovl_alloc_entry() packs lowerstack together with
>> ovl_entry, so the overall memory usage of the long lived overlay
>> dentry cache entries is lower.
>
> For regular file the maximum numlower is 1, so for optimizing memory
> allocation/free maybe we can put one ovl_path entry inside ovl_entry
> and allocate/deallocate ovl_entry via cache pool and for dir we can
> link to ovl_path array from ovl_entry. Does it make sense?

Yes.  We can do it for dir as well if there's only one lower layer
(it's going to be the common case).

I suggest you look at  dentry->d_name/d_iname for the implementation.

Thanks,
Miklos
