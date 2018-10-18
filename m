Return-Path: <stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Oct 2018 15:25:28 +0200
From: Stefan Agner <stefan@agner.ch>
Subject: Re: WARNING: possible recursive locking detected in
 mnt_want_write/mnt_want_write_file_path
In-Reply-To: <CAOQ4uxjqmQJmE5xLfqJGCnZoMf6NPtcNso7Fotjy_hGAUObK+w@mail.gmail.com>
References: <f6de5a77786759a7308ec8dc6cfe41c6@agner.ch>
 <CAJfpegvn9pXJ9EULD-+HXJJNkH58CSB5TEhpv3udHFo47BqeNQ@mail.gmail.com>
 <CAOQ4uxgcsHXZ3ctE1NNMey_y_LNagtx_n+Tdq7SApT6EgLsd0Q@mail.gmail.com>
 <CAJfpegsAvjfixdO9iRDsV2XwvGaQS9GpbBdkKnkxJS=3ghcZ-g@mail.gmail.com>
 <CAOQ4uxjqmQJmE5xLfqJGCnZoMf6NPtcNso7Fotjy_hGAUObK+w@mail.gmail.com>
Message-ID: <b9f68a97417b5d907e8e882b9e8d19a1@agner.ch>
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Sasha Levin <alexander.levin@microsoft.com>, overlayfs <linux-unionfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
List-ID: <linux-unionfs@vger.kernel.org>

On 18.10.2018 13:50, Amir Goldstein wrote:
> On Wed, Oct 17, 2018 at 9:37 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> On Wed, Oct 17, 2018 at 5:24 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> 
>> > Miklos,
>> >
>> > You must have confused "the algorithm" by including a "fix" commit in
>> > rc1 pull request
>> > without mentioning that it "Fixes" a commit in the same pull request.
>>
>> I didn't know there were heuristics other than "Cc: stable@.."
>>
> 
> Yes. Given a Fixes: label, I bet Cc: stable is not needed to auto select
> for stable??

Given a Fixes: probably would prevented it to be selected since the
commit it references is not part of 4.18...

Anyway, as expected, reverting the commit on stable 4.18.4 fixes the
warning for me.

Thanks for tracking down!

--
Stefan

> 
> Sasha,
> 
> Please note that lack of Fixes: or Cc: stable from some subsystems
> is a rather strong indication for NOT for stable.
> 
> I suppose that in case of stable branch regression due to incorrect
> patch selection there is a strong negative feedback to the algorithm?
> 
> Thanks,
> Amir.
