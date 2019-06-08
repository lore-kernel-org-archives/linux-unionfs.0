Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190607010431.11868-1-mcoffin13@gmail.com> <20190607205105.21858-1-mcoffin13@gmail.com>
 <CAOQ4uximPqsNivkqD36LdNfT4g41v2rtDm+OB6t2z40dpWs_og@mail.gmail.com> <f5b0bddd-678b-bdd9-6fc7-cc9e5b3211e5@gmail.com>
In-Reply-To: <f5b0bddd-678b-bdd9-6fc7-cc9e5b3211e5@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 8 Jun 2019 21:47:08 +0300
Message-ID: <CAOQ4uxjQQcrcpxhtu3kAJvGaK+xd5TfNB=7_UnNciGj990DN6Q@mail.gmail.com>
Subject: Re: [PATCH v2] overlay: allow config override of metacopy/redirect defaults
Content-Type: text/plain; charset="UTF-8"
To: Matt Coffin <mcoffin13@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Jun 8, 2019 at 8:28 PM Matt Coffin <mcoffin13@gmail.com> wrote:
>
> Thanks for the comments, Amir. It's my first kernel patch so it's a
> learning process.
>
> I'll take a stab at fleshing out what the documentation would look like
> for a different config system, and submit a patch for the redirect_dir
> not showing in procfs bug. Unless there's opposition, I'll also add a
> log line (similar to the one that warns about disabling metacopy) for
> when redirect_dir becomes enabled due to an explicitly configured
> metacopy for the mount point. A line like that in dmesg would have saved
> me a log of trouble trying to figure out WHY this was happening in the
> first place.

No objection. You *are* the user so you are the proof that a message
is useful.

>
> As far as docker goes, I think you're absolutely correct there. There's
> no reason that the overlay2 backend shouldn't be passing these
> parameters explicitly to the mount point. That said, even with the
> visibility improvements above, it does seem odd to me that passing
> "redirect_dir=0" explicitly to the module wouldn't actually disable it,
> just because the "metacopy" parameter is defaulting it to being on. Even
> if we display the overridden options in /proc/mounts, and log in dmesg,
> it seems odd to me that a default on another setting would override an
> explicitly passed other setting.
>
> Hopefully, there won't be many people actually doing that globally once
> the overlay2 backend behaves properly, but it still seems like odd
> behavior to me; but, if that's intended and desired then it's not the
> end of the world.
>

I think nobody disagrees that current  behavior is sub-optimal,
but the general vibe is that to fix a corner case of configuration
would take a lot of effort and a lot of added code complexity, so
the trade off may not be worth it (as long as we duly report what's
happened to user). OTOH, the options parsing code is a bit kludgy
already. If you are able to make it better and in the process improve
the behavior, that would be worth while IMO.

> Thanks again for the comments and working with me. Sorry if the
> [How]/[Why] formatting isn't the standard here, I just pulled it from
> the amd-gfx mailing list since I've never submitted a patch before.
>

It may not be the standard format, but it providing the Why and the How
should definitely be the standard.

> So, if one were to take a stab at implementing a more generic
> configuration approach, what would the ideal desired behavior for the
> options look like?
>
> 1. Should kernel config not be override-able? The current behavior is to
> allow overriding kernel config with mount options/params. It might be
> confusing to change that, so likely the desire would be to keep the
> existing behavior?
> 2. Should mount options take precedence over module params? The current
> behavior is that mount options take precedence, and likely I think
> that's desired as well.

There is a clear hierarchy for the config options.
module parameter overrides build config.
mount option overrides both.

The problem is that in the general case, once a mount option has been
parsed and config value modified, we loose the origin of that config value.
metacopy_opt/redirect_opt were added as a band aid to address a specific
issue. That's a special case code not generic code.

One possible way to generalize this code would be to keep the entire
information, i.e. the builds defaults, the module param defaults and
the mount options that can override them in a data structure that could
be processed in a generic way and also a data structure that can represent
the inter-dependencies between the options.

And then every time that a feature needs to be turned off for some reason
that also needs to be taken into account.
IOW, I advise against diving into this mess. You have been warned ;-)

Thanks,
Amir.
