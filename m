Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALLuPvoQv5SpqXZ8RG4aagce7qZ4uscLiHT2LCYfwrR4_qySzQ@mail.gmail.com>
References: <CALLuPvpczs-UiDkoHURAu7weCHJCv9U6xKxDKck=5U85T55ukw@mail.gmail.com>
 <CALLuPvr+z_NiGVBDhOOtsahjSo0Vn9Y5wi+Pg6FDvFjKkwZPZA@mail.gmail.com>
 <CAOQ4uxi1qFM5UguMswnAWWCGNVwzNYMr_rJtN=+Bt9tUhhPFuA@mail.gmail.com>
 <1521120161.86246.4.camel@primarydata.com> <CALLuPvooC7jjPRPfGc3MPKN0bX3aiN_51A_9ugs+1Sk3=sshzA@mail.gmail.com>
 <CAOQ4uxhO6rEA+gru45ZuWc-9twRguuPRmfZmQiTfQu+QKTtM7w@mail.gmail.com>
 <CAOQ4uxhxMKL1-gQdgsChG=EUNH+wVnfxrXkkO-nyas4wdfdtyQ@mail.gmail.com>
 <CALLuPvpncQ7nXNb1Sg5zSUj6cqbQydB0G=d70jf=1LHYgC5WhQ@mail.gmail.com>
 <CAOQ4uxh7Eqk9Hf4mYn6s0AwCUOS0Xoh4tLzQyrDJJE72wjEadQ@mail.gmail.com> <CALLuPvoQv5SpqXZ8RG4aagce7qZ4uscLiHT2LCYfwrR4_qySzQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 16 Mar 2018 11:50:40 +0200
Message-ID: <CAOQ4uxjHnO+zw4TVXD78WM6nw3VXfUjN0ReKo7PGS98zT9FuaQ@mail.gmail.com>
Subject: Re: readdir returns d_type=DT_UNKNOWN to overlay exported dir (NFSv3)
Content-Type: text/plain; charset="UTF-8"
To: Eddie Horng <eddiehorng.tw@gmail.com>
Cc: Trond Myklebust <trondmy@primarydata.com>, "bfields@fieldses.org" <bfields@fieldses.org>, "miklos@szeredi.hu" <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "jlayton@kernel.org" <jlayton@kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Mar 16, 2018 at 10:06 AM, Eddie Horng <eddiehorng.tw@gmail.com> wrote:
> 2018-03-16 15:23 GMT+08:00 Amir Goldstein <amir73il@gmail.com>:
[...]
>>> Hi Amir,
>>> The patch works like a charm in my first test, but when I switch lower
>>> layer to different fs then upper and merged, problem comes again. The
>>
>> Yes, that is expected. As I explained, overlayfs does NOT guaranty consistency
>> of d_ino to st_ino with non-samefs and this patch doesn't change that.
>> Apparently, the consequence is that with NFSv3 you will get DT_UNKNOWN.
>>
>> If this is really a problem for your use case, I have already posted a solution
>> for non-samefs while back https://github.com/amir73il/linux/commits/ovl-xino
>> I can rebase and re-post if you are interested in testing.
>> Can I assume from your test example that you are interested in the setup of
>> ext4 as upper/lower (but non samefs)? Because solving the problem for ext4
>> (32bit ino) is a bit simpler than the general case (64bit ino).
>>
>> Thanks,
>> Amir.
>
> My setup for upper is ext4, lower however is a proprietary fs, whose
> ino is 32bit.
> So far it has identical behavior as ext4 to work with overlay. I'm
> glad to test if the solution works
> for ext4 or the proprietary fs.
> In the other hand, I also try to submit a request to Google to see if
> the build tool can handle
> DT_UNKNOWN properly, after all the application use d_type should do that.
>

Eddie,

I rebased and push branch ovl-xino [1] to my github, it includes the
fix you already
tested.

If your proprietary filesystem does not implement the operation encode_fh()
and uses the default 32INO encoding then you don't have to specify any new
mount option. If it implements its own file handle encoding, you need to specify
overlay mount option -o xino to declare that all inode numbers are
limited to 32bit
(or at least not using 64bit).

Cheers,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-xino
