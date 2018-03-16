Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALLuPvpJ+dQ7oh7Hr=nVUMiwYC=GZb=j08n7OCht+9o9tFKJwg@mail.gmail.com>
References: <CALLuPvpczs-UiDkoHURAu7weCHJCv9U6xKxDKck=5U85T55ukw@mail.gmail.com>
 <CALLuPvr+z_NiGVBDhOOtsahjSo0Vn9Y5wi+Pg6FDvFjKkwZPZA@mail.gmail.com>
 <CAOQ4uxi1qFM5UguMswnAWWCGNVwzNYMr_rJtN=+Bt9tUhhPFuA@mail.gmail.com>
 <1521120161.86246.4.camel@primarydata.com> <CALLuPvooC7jjPRPfGc3MPKN0bX3aiN_51A_9ugs+1Sk3=sshzA@mail.gmail.com>
 <CAOQ4uxhO6rEA+gru45ZuWc-9twRguuPRmfZmQiTfQu+QKTtM7w@mail.gmail.com>
 <CAOQ4uxhxMKL1-gQdgsChG=EUNH+wVnfxrXkkO-nyas4wdfdtyQ@mail.gmail.com>
 <CALLuPvpncQ7nXNb1Sg5zSUj6cqbQydB0G=d70jf=1LHYgC5WhQ@mail.gmail.com>
 <CAOQ4uxh7Eqk9Hf4mYn6s0AwCUOS0Xoh4tLzQyrDJJE72wjEadQ@mail.gmail.com>
 <CALLuPvoQv5SpqXZ8RG4aagce7qZ4uscLiHT2LCYfwrR4_qySzQ@mail.gmail.com>
 <CAOQ4uxjHnO+zw4TVXD78WM6nw3VXfUjN0ReKo7PGS98zT9FuaQ@mail.gmail.com> <CALLuPvpJ+dQ7oh7Hr=nVUMiwYC=GZb=j08n7OCht+9o9tFKJwg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 16 Mar 2018 17:28:46 +0200
Message-ID: <CAOQ4uxi0kGssgTuc=y8yd6dLxN_q4viS487mdKLjgBPKbYO6Ag@mail.gmail.com>
Subject: Re: readdir returns d_type=DT_UNKNOWN to overlay exported dir (NFSv3)
Content-Type: text/plain; charset="UTF-8"
To: Eddie Horng <eddiehorng.tw@gmail.com>
Cc: Trond Myklebust <trondmy@primarydata.com>, "bfields@fieldses.org" <bfields@fieldses.org>, "miklos@szeredi.hu" <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "jlayton@kernel.org" <jlayton@kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Mar 16, 2018 at 5:06 PM, Eddie Horng <eddiehorng.tw@gmail.com> wrote:
>> Eddie,
>>
>> I rebased and push branch ovl-xino [1] to my github, it includes the
>> fix you already
>> tested.
>>
>> If your proprietary filesystem does not implement the operation encode_fh()
>> and uses the default 32INO encoding then you don't have to specify any new
>> mount option. If it implements its own file handle encoding, you need to specify
>> overlay mount option -o xino to declare that all inode numbers are
>> limited to 32bit
>> (or at least not using 64bit).
>>
>> Cheers,
>> Amir.
>>
>> [1] https://github.com/amir73il/linux/commits/ovl-xino
>
> I tested ovl-xino with my proprietary filesystem and ext4, the result
> is great -- readdir returns correct d_type.
> Really thanks your effort to find root cause and provide solution so fast.
> In addition, do you plan to merge the fix or even the xino feature in 4.16?
>

I am not the one doing the merging. Miklos does.
I posted the fix for samefs and it could get merged to 4.16 if Miklos
has time to review it. May require some pinging from you if that doesn't
happen within a week.

xino feature is not for 4.16. It needs some more work and then I can
re-post it for 4.17.

Cheers,
Amir.
